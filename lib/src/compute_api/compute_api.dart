import 'dart:async';
import 'dart:collection';
import 'dart:isolate';

import 'package:computer/src/errors.dart';
import 'package:computer/src/logger.dart';

import 'task.dart';
import 'worker.dart';

class ComputeAPI {
  final _workers = <Worker>[];

  final _taskQueue = Queue<Task>();

  final _activeTaskCompleters = <Capability, Completer>{};

  Logger _logger;

  bool isRunning = false;

  Future<void> turnOn({
    int workersCount = 2,
    bool verbose = false,
  }) async {
    _logger = Logger(enabled: verbose);

    _logger.log('Turning on');

    for (var i = 0; i < workersCount; i++) {
      _logger.log('Starting worker $i...');
      final worker = Worker('worker$i');
      await worker.init(onResult: _onTaskFinished, onError: _onTaskFailed);
      _workers.add(worker);
      _logger.log('Worker $i has started');
    }

    isRunning = true;
  }

  Future<R> compute<P, R>(
    Function fn, {
    P param,
  }) async {
    _logger.log('Started computation');

    final taskCapability = Capability();
    final taskCompleter = Completer<R>();

    final task = Task(
      task: fn,
      param: param,
      capability: taskCapability,
    );

    _activeTaskCompleters[taskCapability] = taskCompleter;

    final freeWorker = _findFreeWorker();

    if (freeWorker == null) {
      _logger.log('No free workers, add task to the queue');
      _taskQueue.add(task);
    } else {
      _logger.log('Found free worker, executing on it');
      freeWorker.execute(task);
    }

    final result = await taskCompleter.future;
    return result;
  }

  Future<void> turnOff() async {
    _logger.log('Turning off computer...');
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

    _workers.clear();
    _taskQueue.clear();

    isRunning = false;

    _logger.log('Turned off computer');
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
      _logger.log("Finished task on worker, queue isn't empty, pick task");
      final task = _taskQueue.removeFirst();
      worker.execute(task);
    }
  }

  void _onTaskFailed(RemoteExecutionError error, Worker worker) {
    final taskCompleter = _activeTaskCompleters.remove(error.taskCapability);
    taskCompleter.completeError(error);

    if (_taskQueue.isNotEmpty) {
      _logger.log("Finished task on worker, queue isn't empty, pick task");
      final task = _taskQueue.removeFirst();
      worker.execute(task);
    }
  }
}
