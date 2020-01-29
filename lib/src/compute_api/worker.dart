import 'dart:async';
import 'dart:isolate';

import 'package:computer/src/error.dart';
import 'package:meta/meta.dart';

import 'task.dart';

typedef OnResultFunction = void Function(TaskResult result, Worker worker);
typedef OnErrorFunction = void Function(RemoteExecutionError error, Worker worker);

enum WorkerStatus { idle, processing }

class IsolateInitParams {
  SendPort sendPort;

  IsolateInitParams({@required this.sendPort});
}

class Worker {
  final String name;

  WorkerStatus status = WorkerStatus.idle;

  Isolate _isolate;
  SendPort _sendPort;
  ReceivePort _receivePort;
  Stream _broadcastReceivePort;

  StreamSubscription _broadcastPortSubscription;

  Worker(this.name);

  Future<void> init({
    @required OnResultFunction onResult,
    @required OnErrorFunction onError,
  }) async {
    _receivePort = ReceivePort();

    _isolate = await Isolate.spawn(
      isolateEntryPoint,
      IsolateInitParams(
        sendPort: _receivePort.sendPort,
      ),
      debugName: name,
      errorsAreFatal: false,
    );

    _broadcastReceivePort = _receivePort.asBroadcastStream();

    _sendPort = await _broadcastReceivePort.first;

    _broadcastPortSubscription = _broadcastReceivePort.listen((res) {
      status = WorkerStatus.idle;
      if (res is RemoteExecutionError) {
        onError(res, this);
        return;
      }
      onResult(res, this);
    });
  }

  void execute(Task task) {
    status = WorkerStatus.processing;
    _sendPort.send(task);
  }

  Future<void> dispose() async {
    await _broadcastPortSubscription.cancel();
    _isolate.kill();
    _receivePort.close();
  }
}

Future<void> isolateEntryPoint(IsolateInitParams params) async {
  final receivePort = ReceivePort();
  final sendPort = params.sendPort;

  sendPort.send(receivePort.sendPort);

  await for (final Task task in receivePort) {
    try {
      final computationResult = await task.task(task.param);
      final result = TaskResult(
        result: computationResult,
        capability: task.capability,
      );
      sendPort.send(result);
    } catch (error) {
      sendPort.send(RemoteExecutionError(error.toString(), task.capability));
    }
  }
}
