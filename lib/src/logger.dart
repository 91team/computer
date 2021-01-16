class Logger {
  Logger({required this.enabled});

  final bool enabled;

  void log(String message) {
    if (enabled) {
      print('[Computer][${DateTime.now()}] $message');
    }
  }
}
