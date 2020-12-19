import 'package:flutter/material.dart';
import 'package:hda_driver/pages/add-vehicle.dart';
import 'package:hda_driver/pages/edit-profile.dart';
import 'package:hda_driver/pages/home.dart';
import 'package:hda_driver/pages/legal-documents.dart';
import 'package:hda_driver/pages/otpVerify.dart';
import 'package:hda_driver/pages/profile.dart';
import 'package:hda_driver/pages/rating.dart';
import 'package:hda_driver/pages/signIn.dart';
import 'package:hda_driver/pages/signUp.dart';
import 'package:hda_driver/pages/vehicle-form.dart';
import 'package:hda_driver/pages/vehicle-reviewing.dart';
import 'package:hda_driver/screen-arguments/otp-verify-arguments.dart';
import 'package:hda_driver/screen-arguments/rating-arguments.dart';
import 'package:hda_driver/screen-arguments/sign-in-arguments.dart';
import 'package:hda_driver/screen-arguments/vehicle-reviewing-arguments.dart';
import 'constants.dart';

class HdaRouter {
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
      case addVehicleRoute:
        return MaterialPageRoute(builder: (_) => AddVehiclePage());
      case vehicleFormRoute:
        return MaterialPageRoute(builder: (_) => VehicleFormPage());
      case documentUploadRoute:
        return MaterialPageRoute(builder: (_) => LegalDocumentsUploadPage());
      case vehicleReviewingRoute:
        final VehicleReviewingArguments args = settings.arguments;
        return MaterialPageRoute(
            builder: (_) => VehicleReviewingPage(vehicle: args?.vehicle));
      case ratingRoute:
        final RatingArguments args = settings.arguments;
        return MaterialPageRoute(
            builder: (_) => RatingPage(tripService: args.tripService));
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                body: Center(
                    child: Text('No route defined for ${settings.name}'))));
    }
  }
}
