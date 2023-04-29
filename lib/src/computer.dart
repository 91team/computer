import 'dart:async';

import 'compute_api/compute_api.dart';

/// Class, that provides `compute` like API for concurrent calculations
class Computer {
  final _computeDelegate = ComputeAPI();

  factory Computer.shared() => _singleton;

  factory Computer.create() => Computer._internal();

  Computer._internal();

  static final _singleton = Computer._internal();

  /// Returns `true` if `Computer` turned on and `false` otherwise
  bool get isRunning => _computeDelegate.isRunning;

  /// Turn on `Computer`, `workersCount` should not be less than 1, default is 2
  /// `verbose` is false by default, enabling it leads to logging of every operation
  Future<void> turnOn({
    int workersCount = 2,
    bool verbose = false,
  }) async {
    return _computeDelegate.turnOn(
      workersCount: workersCount,
      verbose: verbose,
    );
  }

  /// Executes function `fn` with passed `param`. Takes only top-level functions and static methods.
  /// `P` is `param` type, `R` is function return type
  /// `taskName` is a identifier for the task that's only used during logging
  Future<R> compute<P, R>(
    Function fn, {
    P? param,
    String? taskName,
  }) async {
    return _computeDelegate.compute<P, R>(fn, param: param, taskName: taskName);
  }

  /// Turn off `Computer`
  Future<void> turnOff() async {
    return _computeDelegate.turnOff();
  }
}
