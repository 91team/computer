import 'dart:async';
import 'dart:isolate';

import 'package:computer/src/errors.dart';

import 'task.dart';

typedef OnResultCallback = void Function(
  TaskResult result,
  Worker worker,
);

typedef OnErrorCallback = void Function(
  RemoteExecutionError error,
  Worker worker,
);

enum WorkerStatus { idle, processing }

class IsolateInitParams {
  SendPort sendPort;

  IsolateInitParams({required this.sendPort});
}

class Worker {
  final String name;

  WorkerStatus status = WorkerStatus.idle;

  late final Isolate _isolate;
  late final SendPort _sendPort;
  late final ReceivePort _receivePort;
  late final Stream _broadcastReceivePort;
  late final StreamSubscription _broadcastPortSubscription;

  Worker(this.name);

  Future<void> init({
    required OnResultCallback onResult,
    required OnErrorCallback onError,
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

    _sendPort = await _broadcastReceivePort.first as SendPort;

    _broadcastPortSubscription = _broadcastReceivePort.listen((dynamic res) {
      status = WorkerStatus.idle;
      if (res is RemoteExecutionError) {
        onError(res, this);
        return;
      }
      onResult(res as TaskResult, this);
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

  await for (final Task task in receivePort.cast<Task>()) {
    try {
      final shouldPassParam = task.param != null;

      final dynamic computationResult = shouldPassParam ? await task.task(task.param) : await task.task();

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
