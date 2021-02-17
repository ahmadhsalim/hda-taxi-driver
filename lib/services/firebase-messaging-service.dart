import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hda_driver/resources/trip-resource.dart';
import 'package:hda_driver/services/service-locator.dart';

import 'identity-service.dart';

class FirebaseMessagingService {
  Identity identity = getIt<Identity>();
  FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  static TripResource tripResource;

  static void tripRequested(Map<String, dynamic> data) {
    print([data, 'triipi-requestedddd']);
  }

  static Future<dynamic> myBackgroundMessageHandler(
      Map<String, dynamic> message) async {
    if (message.containsKey('notification')) {}

    // if (message.containsKey('notification')) {
    //   // Handle notification message
    //   final dynamic notification = message['notification'];
    // }

    // Or do other work.
  }

  Future initialize() async {
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        // _showItemDialog(message);
      },
      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        // _navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        // _navigateToItemDetail(message);
      },
    );
    firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true));
    firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    String token = await firebaseMessaging.getToken();
    assert(token != null);
    identity.setFirebaseToken(token);
  }
}
