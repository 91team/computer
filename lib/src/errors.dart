import 'dart:isolate';

class ComputerError implements Exception {
  final String message;

  ComputerError(this.message);

  @override
  String toString() => message;
}

class RemoteExecutionError extends ComputerError {
  final Capability taskCapability;

  RemoteExecutionError(
    String message,
    this.taskCapability,
  ) : super(message);
}

class CancelExecutionError extends ComputerError {
  final Capability taskCapability;

  CancelExecutionError(String message, this.taskCapability) : super(message);
}
