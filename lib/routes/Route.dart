import 'package:flutter/material.dart';
import 'package:hda_driver/pages/book.dart';
import 'package:hda_driver/pages/drop-off-selection.dart';
import 'package:hda_driver/pages/edit-profile.dart';
import 'package:hda_driver/pages/home.dart';
import 'package:hda_driver/pages/otpVerify.dart';
import 'package:hda_driver/pages/profile.dart';
import 'package:hda_driver/pages/signIn.dart';
import 'package:hda_driver/pages/signUp.dart';
import 'package:hda_driver/screen-arguments/book-arguments.dart';
import 'package:hda_driver/screen-arguments/drop-off-selection-arguments.dart';
import 'package:hda_driver/screen-arguments/otp-verify-arguments.dart';
import 'package:hda_driver/screen-arguments/sign-in-arguments.dart';
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
      // case pickLocationRoute:
      //   final PickLocationArguments args = settings.arguments;
      //   return MaterialPageRoute(
      //       builder: (_) => PickLocation(cameraPosition: args.position));
      case dropOffSelectionRoute:
        final DropOffSelectionArguments args = settings.arguments;
        return MaterialPageRoute(
            builder: (_) => DropOffSelectionPage(trip: args.trip));
      case bookRoute:
        final BookArguments args = settings.arguments;
        return MaterialPageRoute(builder: (_) => BookPage(trip: args.trip));
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                body: Center(
                    child: Text('No route defined for ${settings.name}'))));
    }
  }
}
