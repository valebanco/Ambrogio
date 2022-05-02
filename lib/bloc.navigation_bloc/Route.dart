import 'package:flutter/material.dart';
import 'package:loggingoogle/pages/FeedBackPage.dart';
import 'package:loggingoogle/pages/MySegnalation.dart';
import '../pages/homepage.dart';
import '../pages/SegnalationOption.dart';
import '../pages/UploadPhoto.dart';
import '../pages/OtherSegnalation.dart';
class Routes {
  static Route<dynamic> generateRoute(String name) {
    switch (name) {
      case '/':
        return MaterialPageRoute(
          builder: (context) => Dashboard(),
        );
        break;
      case '/SegnalationOption':
        return MaterialPageRoute(
          builder: (context) => SegnalationOptions(),
        );
        break;
      case '/SegnalationOption/UploadPhoto':
        return MaterialPageRoute(
          builder: (context) => UploadPhoto(),
        );
        break;

      case '/SegnalationOption/OtherSegnalation':
        return MaterialPageRoute(
          builder: (context) => OtherSegnalation(),
        );
        break;

      case '/SegnalationOption/UploadPhoto/Success':
        return MaterialPageRoute(
          builder: (context) => SegnalationSuccess(),
        );
        break;
      case '/MySegnalation':
        return MaterialPageRoute(
          builder: (context) => MySegnalation(),
        );
        break;
      case '/SendFeedback':
        return MaterialPageRoute(
          builder: (context) => Success(),
        );
        break;

        default:
        return MaterialPageRoute(
          builder: (context) => Dashboard(),
        );
    }
  }
}
