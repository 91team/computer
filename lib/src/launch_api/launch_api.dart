import 'defs.dart';
import 'process.dart';

class LaunchAPI {
  List<Process> processes = [];

  Process<T> launch<T extends Launchable>(CreateIsolateLaunchable createIsolateLaunchable) {
    final process = Process<T>();
    process.run(createIsolateLaunchable);
    processes.add(process);
    return process;
  }
}
