import 'package:bloc/bloc.dart';
import 'package:loggingoogle/pages/Settings.dart';
import '../pages/MySegnalation.dart';
import '../pages/MyFeedback.dart';
import '../pages/homepage.dart';
import '../pages/Settings.dart';

enum NavigationEvents {
  ProfileScreenClickedEvent,
  MySegnalationEvent,
  MyFeedBackEvent,
  SettingsEvent,
}


abstract class NavigationStates {}

class NavigationBloc extends Bloc<NavigationEvents, NavigationStates> {
  @override
  NavigationStates get initialState => Dashboard();

  @override
  Stream<NavigationStates> mapEventToState(NavigationEvents event) async* {
    switch (event) {
      case NavigationEvents.ProfileScreenClickedEvent:
        yield Dashboard();
        break;

      case NavigationEvents.MyFeedBackEvent:
        yield MyFeedBack();
        break;

      case NavigationEvents.MySegnalationEvent:
        yield MySegnalation();
        break;

      case NavigationEvents.SettingsEvent:
        yield Settings();
        break;
    }
  }
}
