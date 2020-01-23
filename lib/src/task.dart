import 'dart:isolate';
import 'package:meta/meta.dart';

class Task {
  final Function task;
  final dynamic param;
  final Duration timeout;
  final Capability capability;

  Task({
    @required this.task,
    @required this.capability,
    this.param,
    this.timeout,
  });
}

class TaskResult {
  final dynamic result;
  final Capability capability;

  TaskResult({
    @required this.result,
    @required this.capability,
  });
}
