import 'launchable.dart';
import 'process.dart';

class LaunchAPI {
  Process<T> launch<T extends Launchable>(CreateIsolateLaunchable createIsolateLaunchable) {
    final process = Process<T>();
    process.run(createIsolateLaunchable);
    return process;
  }
}
