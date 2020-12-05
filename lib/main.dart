import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hda_driver/pages/splash.dart';
import 'package:hda_driver/routes/hda-router.dart';
import 'package:hda_driver/services/analytics-service.dart';
import 'package:hda_driver/services/service-locator.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

Future<void> main() async {
  setupServiceLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(HdaApp());
}

class HdaApp extends StatelessWidget {
  static AnalyticsService analytics = getIt<AnalyticsService>();
  static FirebaseAnalyticsObserver analyticsObserver =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HDA Driver',
      navigatorObservers: [routeObserver, analyticsObserver],
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        canvasColor: Colors.transparent,
      ),
      onGenerateRoute: HdaRouter.generateRoute,
      home: SplashPage(),
    );
  }
}
