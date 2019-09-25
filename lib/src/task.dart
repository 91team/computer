import 'dart:async';
import 'dart:isolate';

import 'package:meta/meta.dart';

typedef TaskCallback<P, R> = FutureOr<R> Function(P param);

class Task<P, R> {
  final TaskCallback<P, R> task;
  final P param;
  final Duration timeout;
  final Capability capability;

  Task({
    @required this.task,
    @required this.capability,
    this.param,
    this.timeout,
  });
}

class TaskResult<R> {
  final R result;
  final Capability capability;

  TaskResult({
    @required this.result,
    @required this.capability,
  });
}
