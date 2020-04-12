class Logger {
  static bool _isEnabled = false;

  static void log(String message) {
    if (_isEnabled) {
      print('[Computer] $message [${DateTime.now()}]');
    }
  }

  static void enable() {
    _isEnabled = true;
  }

  static void disable() {
    _isEnabled = false;
  }
}
