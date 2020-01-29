abstract class Command {
  //
}

abstract class Reply {
  //
}

abstract class Launchable {
  void launch();
  void terminate();
}

abstract class IsolateSideLaunchable {
  void dispatch(Command command);
  void launch();
  void terminate();
}
