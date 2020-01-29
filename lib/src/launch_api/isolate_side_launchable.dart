import 'command.dart';

abstract class IsolateSideLaunchable {
  void dispatch(Command command);
}
