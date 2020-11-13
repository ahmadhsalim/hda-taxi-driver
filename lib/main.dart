import 'package:flutter/material.dart';
import 'package:hda_driver/pages/splash.dart';
import 'package:hda_driver/routes/Route.dart';
import 'package:hda_driver/services/service-locator.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() {
  setupServiceLocator();
  runApp(HdaApp());
}

class HdaApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HDA Driver',
      navigatorObservers: [routeObserver],
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        canvasColor: Colors.transparent,
      ),
      onGenerateRoute: Router.generateRoute,
      home: SplashPage(),
    );
  }
}
