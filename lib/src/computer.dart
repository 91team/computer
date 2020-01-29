import 'dart:async';
import 'dart:collection';
import 'dart:isolate';

import 'package:computer/src/error.dart';
import 'package:computer/src/logger.dart';

import 'task.dart';
import 'worker.dart';

/// Singleton, that provides compute() like API for concurrent calculations

class Computer {
  static final Computer _instance = Computer._internal();

  factory Computer() {
    return _instance;
  }

  Computer._internal();

  List<Worker> _workers;
  Queue<Task> _taskQueue;

  final Map<Capability, Completer> _activeTaskCompleters = {};

  /// Before any computation you need to turn on the Computer

  Future<void> turnOn({
    int workersCount = 2,
    bool areLogsEnabled,
  }) async {
    if (areLogsEnabled) {
      Logger.enable();
    }

    Logger.log('Turning on');
    _workers = [];
    _taskQueue = Queue();

    for (var i = 0; i < workersCount; i++) {
      Logger.log('Starting worker $i...');
      final worker = Worker('worker$i');
      await worker.init(onResult: _onTaskFinished, onError: _onTaskFailed);
      _workers.add(worker);
      Logger.log('Worker $i has started');
    }
  }

  /// Executes function with passed param. Takes only global functions & static methods.

  Future<R> compute<P, R>(
    Function fn, {
    P param,
    // Duration timeout,
  }) async {
    Logger.log('Started computation');

    final taskCapability = Capability();
    final taskCompleter = Completer<R>();

    final task = Task(
      task: fn,
      param: param,
      // timeout: timeout,
      capability: taskCapability,
    );

    _activeTaskCompleters[taskCapability] = taskCompleter;

    final freeWorker = _findFreeWorker();

    if (freeWorker == null) {
      Logger.log('No free workers, add task to the queue');
      _taskQueue.add(task);
    } else {
      Logger.log('Found free worker, executing on it');
      freeWorker.execute(task);
    }

    final result = await taskCompleter.future;
    return result;
  }

  /// If you don't need workers anymore, you should turn off the computer

  Future<void> turnOff() async {
    Logger.log('Turning off computer...');
    for (final worker in _workers) {
      await worker.dispose();
    }
    _activeTaskCompleters.forEach((taskCapability, completer) {
      if (!completer.isCompleted) {
        completer.completeError(RemoteExecutionError(
          'Canceled because of computer turn off',
          taskCapability,
        ));
      }
    });
    _activeTaskCompleters.clear();

    Logger.log('Turned off computer');
  }

  Worker _findFreeWorker() {
    return _workers.firstWhere(
      (worker) => worker.status == WorkerStatus.idle,
      orElse: () => null,
    );
  }

  void _onTaskFinished(TaskResult result, Worker worker) {
    final taskCompleter = _activeTaskCompleters.remove(result.capability);
    taskCompleter.complete(result.result);

    if (_taskQueue.isNotEmpty) {
      Logger.log("Finished task on worker, queue isn't empty, pick task");
      final task = _taskQueue.removeFirst();
      worker.execute(task);
    }
  }

  void _onTaskFailed(RemoteExecutionError error, Worker worker) {
    final taskCompleter = _activeTaskCompleters.remove(error.taskCapability);
    taskCompleter.completeError(error);

    if (_taskQueue.isNotEmpty) {
      Logger.log("Finished task on worker, queue isn't empty, pick task");
      final task = _taskQueue.removeFirst();
      worker.execute(task);
    }
  }
}
