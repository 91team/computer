import 'dart:async';

import 'compute_api/compute_api.dart';

/// Class, that provides `compute` like API for concurrent calculations
class Computer {
  final _computeDelegate = ComputeAPI();

  /// Completes when the computer is turned on, null when it is turned off
  Completer? _completer;

  factory Computer.shared() => _singleton;

  factory Computer.create() => Computer._internal();

  Computer._internal();

  static final _singleton = Computer._internal();

  /// Returns `true` if `Computer` turned on and `false` otherwise
  bool get isRunning => _computeDelegate.isRunning;

  /// Turn on `Computer`, `workersCount` should be more than 0, default is 2
  /// `verbose` is false by default, enabling it leads to logging of every operation
  Future<void> turnOn({
    int workersCount = 2,
    bool verbose = false,
  }) async {
    assert(workersCount > 0, 'workersCount should be more than 0');
    if (isRunning) return;
    _completer = Completer<void>();
    await _computeDelegate.turnOn(
      workersCount: workersCount,
      verbose: verbose,
    );
    _completer?.complete();
  }

  /// Executes function `fn` with passed `param`. Takes only top-level functions and static methods.
  /// `P` is `param` type, `R` is function return type
  /// Throws when turnOn has not been called or waits for turnOn completion
  Future<R> compute<P, R>(
    Function fn, {
    P? param,
  }) async {
    if (_completer == null) {
      throw StateError('Computer is not running, you must run turnOn first!');
    }
    await _completer!.future;
    return _computeDelegate.compute<P, R>(fn, param: param);
  }

  /// Turn off `Computer`
  Future<void> turnOff() async {
    await _completer?.future;
    await _computeDelegate.turnOff();
    _completer = null;
  }
}
