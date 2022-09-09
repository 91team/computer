import 'dart:isolate';

class Task {
  final Function task;
  final dynamic param;
  final Capability capability;

  Task({
    required this.task,
    required this.capability,
    this.param,
  });
}

class WorkerCleanUpTask extends Task {
  WorkerCleanUpTask() : super(task: (){}, capability: Capability());
}

class TaskResult {
  final dynamic result;
  final Capability capability;

  TaskResult({
    required this.result,
    required this.capability,
  });
}

class WorkerCleanUpTaskResult extends TaskResult {
  WorkerCleanUpTaskResult() : super(result: null, capability: Capability());
}
