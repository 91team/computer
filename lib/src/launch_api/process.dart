import 'dart:async';
import 'dart:isolate';

import 'package:computer/src/error.dart';
import 'package:computer/src/launch_api/isolate_side_launchable.dart';
import 'package:meta/meta.dart';

import 'command.dart';
import 'reply.dart';

enum ProcessStatus { idle, processing, paused, finished }

typedef CreateIsolateLaunchable = IsolateSideLaunchable Function(SendPort port);

class IsolateInitParams<T> {
  SendPort sendPort;
  CreateIsolateLaunchable createIsolateLaunchable;

  IsolateInitParams({@required this.sendPort, @required this.createIsolateLaunchable});
}

class Process<T> {
  ProcessStatus status = ProcessStatus.idle;

  Isolate _isolate;
  SendPort _sendPort;
  ReceivePort _receivePort;

  Stream _broadcastReceivePort;

  StreamSubscription _broadcastPortSubscription;

  Future<void> run(CreateIsolateLaunchable createIsolateLaunchable, {String name}) async {
    _receivePort = ReceivePort();

    _isolate = await Isolate.spawn(
      isolateEntryPoint,
      IsolateInitParams(sendPort: _receivePort.sendPort, createIsolateLaunchable: createIsolateLaunchable),
      debugName: name,
      errorsAreFatal: false,
    );

    _broadcastReceivePort = _receivePort.asBroadcastStream();

    _sendPort = await _broadcastReceivePort.first;

    _broadcastPortSubscription = _broadcastReceivePort.listen(_handleReply);
  }

  void pause() {
    //
  }

  void runCommand(Command command) {
    _sendPort.send(command);
  }

  void runCommandWithReply(Command command) {
    _sendPort.send(command);
  }

  Future<void> dispose() async {
    await _broadcastPortSubscription.cancel();
    _isolate.kill();
    _receivePort.close();
  }

  void _handleReply(dynamic reply) {
    if (reply is Reply) {
    } else {
      throw ReplyExpectedException(reply.runtimeType.toString());
    }
  }
}

Future<void> isolateEntryPoint(IsolateInitParams params) async {
  final receivePort = ReceivePort();
  final sendPort = params.sendPort;

  IsolateSideLaunchable launchable = params.createIsolateLaunchable(sendPort);

  sendPort.send(receivePort.sendPort);

  await for (final command in receivePort) {
    if (command is Command) {
      launchable.dispatch(command);
    } else {
      throw CommandExpectedException(command.runtimeType.toString());
    }
  }
}
