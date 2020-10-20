import 'package:flutter/material.dart';
import 'package:hda_app/pages/home.dart';
import 'package:hda_app/pages/pick-location.dart';
import 'package:hda_app/pages/signIn.dart';
import 'package:hda_app/pages/signUp.dart';
import 'package:hda_app/screen-arguments/pick-location-arguments.dart';
import 'constants.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homeRoute:
        return MaterialPageRoute(builder: (_) => HomePage());
      case signUpRoute:
        return MaterialPageRoute(builder: (_) => SignUpPage());
      case signInRoute:
        return MaterialPageRoute(builder: (_) => SignInPage());
      case pickLocationRoute:
        final PickLocationArguments args = settings.arguments;
        return MaterialPageRoute(
            builder: (_) => PickLocation(cameraPosition: args.position));
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                body: Center(
                    child: Text('No route defined for ${settings.name}'))));
    }
  }
}
