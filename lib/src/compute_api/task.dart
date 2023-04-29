import 'dart:isolate';

class Task {
  final Function task;
  final dynamic param;
  final String? name;

  final Capability capability;

  Task({required this.task, required this.capability, this.param, this.name});
}

class TaskResult {
  final dynamic result;
  final Capability capability;
  final String? name;

  TaskResult({required this.result, required this.capability, this.name});
}
