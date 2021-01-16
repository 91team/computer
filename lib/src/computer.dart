import 'dart:async';

import 'compute_api/compute_api.dart';

/// Class, that provides compute() like API for concurrent calculations

class Computer {
  final _computeDelegate = ComputeAPI();

  bool get isRunning => _computeDelegate.isRunning;

  /// Before any computation you need to turn on the Computer

  Future<void> turnOn({
    int workersCount = 2,
    bool verbose = false,
  }) async {
    return _computeDelegate.turnOn(workersCount: workersCount, verbose: verbose);
  }

  /// Executes function with passed param. Takes only global functions & static methods.

  Future<R> compute<P, R>(
    Function fn, {
    P param,
  }) async {
    return _computeDelegate.compute<P, R>(fn, param: param);
  }

  /// If you don't need workers anymore, you should turn off the computer

  Future<void> turnOff() async {
    return _computeDelegate.turnOff();
  }
}
