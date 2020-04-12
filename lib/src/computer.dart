import 'dart:async';

import 'package:computer/src/launch_api/process.dart';

import 'compute_api/compute_api.dart';
import 'launch_api/defs.dart';
import 'launch_api/launch_api.dart';

export 'launch_api/annotations.dart';

/// Class, that provides compute() like API for concurrent calculations

class Computer {
  final _computeDelegate = ComputeAPI();
  final _launchDelegate = LaunchAPI();

  bool get isRunning => _computeDelegate.isRunning;

  /// Before any computation you need to turn on the Computer

  Future<void> turnOn({
    int workersCount = 2,
    bool areLogsEnabled = false,
  }) async {
    return _computeDelegate.turnOn(workersCount: workersCount, areLogsEnabled: areLogsEnabled);
  }

  /// Executes function with passed param. Takes only global functions & static methods.

  Future<R> compute<P, R>(
    Function fn, {
    P param,
    // Duration timeout,
  }) async {
    return _computeDelegate.compute(fn, param: param);
  }

  /// If you don't need workers anymore, you should turn off the computer

  Future<void> turnOff() async {
    return _computeDelegate.turnOff();
  }

  // Under development, private for now
  /// You can run any long living heavy handlers in isolate and communicate with them like with usual objects
  /// Exists separatly of compute and no need to turn on or turn off

  Future<Process> _launch<T extends IsolateSideLaunchable>(CreateIsolateLaunchable createIsolateLaunchable) async {
    return _launchDelegate.launch(createIsolateLaunchable);
  }
}
