import 'dart:isolate';

class RemoteExecutionError implements Exception {
  final String message;
  final Capability taskCapability;

  RemoteExecutionError(this.message, this.taskCapability);

  @override
  String toString() => message;
}
