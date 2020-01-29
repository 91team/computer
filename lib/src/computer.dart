import 'dart:async';

import 'package:computer/src/launch_api/process.dart';

import 'compute_api/compute_api.dart';
import 'launch_api/defs.dart';
import 'launch_api/launch_api.dart';

/// Class, that provides compute() like API for concurrent calculations

class Computer {
  ComputeAPI computeDelegate = ComputeAPI();
  LaunchAPI launchDelegate = LaunchAPI();

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

  /// You can run any long living heavy handlers in isolate and communicate with them like with usual objects

  Future<Process> launch<T extends IsolateSideLaunchable>(CreateIsolateLaunchable createIsolateLaunchable) async {
    return launchDelegate.launch(createIsolateLaunchable);
  }
}
