import 'package:flutter/material.dart';
import 'package:hda_app/pages/edit-profile.dart';
import 'package:hda_app/pages/home.dart';
import 'package:hda_app/pages/otpVerify.dart';
import 'package:hda_app/pages/pick-location.dart';
import 'package:hda_app/pages/profile.dart';
import 'package:hda_app/pages/signIn.dart';
import 'package:hda_app/pages/signUp.dart';
import 'package:hda_app/screen-arguments/otp-verify-arguments.dart';
import 'package:hda_app/screen-arguments/pick-location-arguments.dart';
import 'package:hda_app/screen-arguments/sign-in-arguments.dart';
import 'constants.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homeRoute:
        return MaterialPageRoute(builder: (_) => HomePage());
      case profileRoute:
        return MaterialPageRoute(builder: (_) => ProfilePage());
      case editProfileRoute:
        return MaterialPageRoute(builder: (_) => EditProfilePage());
      case signUpRoute:
        return MaterialPageRoute(builder: (_) => SignUpPage());
      case signInRoute:
        final SignInArguments args = settings.arguments;
        String message;
        if (args != null) message = args.message;

        return MaterialPageRoute(builder: (_) => SignInPage(message: message));
      case verifyOtpRoute:
        final OtpVerifyArguments args = settings.arguments;
        return MaterialPageRoute(
            builder: (_) => OtpVerifyPage(
                mobileNumber: args.mobileNumber, cookie: args.cookie));
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
