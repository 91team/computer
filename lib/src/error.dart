import 'dart:isolate';

class RemoteExecutionError {
  final String message;
  final Capability taskCapability;

  RemoteExecutionError(this.message, this.taskCapability);

  @override
  String toString() => message;
}

class CommandExpectedException implements Exception {
  final String cause;

  CommandExpectedException(String actualType) : cause = 'Expected Command, but got object of type $actualType';

  @override
  String toString() {
    return 'CommandExpectedException: $cause';
  }
}

class ReplyExpectedException implements Exception {
  final String cause;

  ReplyExpectedException(String actualType) : cause = 'Expected Command, but got object of type $actualType';

  @override
  String toString() {
    return 'CommandExpectedException: $cause';
  }
}
