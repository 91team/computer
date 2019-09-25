import 'dart:async';
import 'dart:collection';
import 'dart:isolate';

import 'package:computer/src/logger.dart';

import 'task.dart';
import 'worker.dart';

class Computer {
  static Computer _instance = Computer._internal();

  factory Computer() {
    return _instance;
  }

  Computer._internal();

  List<Worker> _workers;
  Queue<Task> _taskQueue;

  Map<Capability, Completer> _activeTaskCompleters = Map();

  Future<void> turnOn({int workersCount = 2}) async {
    Logger.log('Turning on');
    _workers = [];
    _taskQueue = Queue();

    for (int i = 0; i < workersCount; i++) {
      Logger.log('Starting worker $i...');
      Worker worker = Worker();
      await worker.init(onResult: _onTaskFinished);
      _workers.add(worker);
      Logger.log('Worker $i has started');
    }
  }

  Future<R> compute<P, R>(Function fn, {P param, Duration timeout}) async {
    Logger.log('Started computation');

    final taskCapability = Capability();
    final taskCompleter = Completer<R>();

    final Task<P, R> task = Task(
      task: fn,
      param: param,
      timeout: timeout,
      capability: taskCapability,
    );

    _activeTaskCompleters[taskCapability] = taskCompleter;

    Worker freeWorker = _findFreeWorker();

    if (freeWorker == null) {
      Logger.log('No free workers, add task to the queue');
      _taskQueue.add(task);
    } else {
      Logger.log('Found free worker, executing on it');
      freeWorker.execute<P, R>(task);
    }

    R result = await taskCompleter.future;
    return result;
  }

  Future<void> turnOff() async {
    Logger.log('Turning off computer...');
    for (Worker worker in _workers) {
      await worker.dispose();
    }
    Logger.log('Turned off computer');
  }

  Worker _findFreeWorker() {
    return _workers.firstWhere(
      (worker) => worker.status == WorkerStatus.idle,
      orElse: () => null,
    );
  }

  void _onTaskFinished(TaskResult result, Worker worker) {
    Completer taskCompleter = _activeTaskCompleters.remove(result.capability);
    taskCompleter.complete(result.result);

    if (_taskQueue.isNotEmpty) {
      Logger.log("Finished task on worker, queue isn't empty, pick task");
      final task = _taskQueue.removeFirst();
      worker.execute(task);
    }
  }
}
