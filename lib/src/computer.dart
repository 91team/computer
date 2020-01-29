import 'dart:async';

import 'compute_api/compute_api_delegate.dart';

/// Class, that provides compute() like API for concurrent calculations

class Computer {
  ComputeAPI computeDelegate = ComputeAPI();

  /// Before any computation you need to turn on the Computer

  Future<void> turnOn({
    int workersCount = 2,
    bool areLogsEnabled,
  }) async {
    return computeDelegate.turnOn(workersCount: workersCount, areLogsEnabled: areLogsEnabled);
  }

  /// Executes function with passed param. Takes only global functions & static methods.

  Future<R> compute<P, R>(
    Function fn, {
    P param,
    // Duration timeout,
  }) async {
    return computeDelegate.compute(fn, param: param);
  }

  /// If you don't need workers anymore, you should turn off the computer

  Future<void> turnOff() async {
    return computeDelegate.turnOff();
  }
}
