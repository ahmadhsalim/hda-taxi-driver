import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hda_driver/resources/trip-resource.dart';
import 'package:hda_driver/services/service-locator.dart';

import 'identity-service.dart';

class FirebaseMessagingService {
  Identity identity = getIt<Identity>();
  static TripResource tripResource;

  FirebaseMessaging firebaseMessaging;

  FirebaseMessagingService() {
    firebaseMessaging = FirebaseMessaging();
  }

  static void tripRequested(Map<String, dynamic> data) {
    print([data, 'triipi-requestedddd']);
  }

  static Future<dynamic> backgroundMessageHandler(
      Map<String, dynamic> message) async {
    if (message.containsKey('notification')) {
      var notification = message['notification'];
      // switch (notification['channel']) {
      //   case 'trip-request':
      //     tripRequested(Map<String, dynamic>.from(notification));
      //     break;
      //   default:
      // }
    }

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
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        // _navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        // _navigateToItemDetail(message);
      },
      onBackgroundMessage: backgroundMessageHandler,
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
