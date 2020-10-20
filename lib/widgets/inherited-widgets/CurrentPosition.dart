import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class CurrentPosition extends InheritedWidget {
  const CurrentPosition({
    Key key,
    @required this.position,
    @required Widget child,
  }) : assert(position != null),
       assert(child != null),
       super(key: key, child: child);

  final Position position;

  static CurrentPosition of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CurrentPosition>();
  }

  @override
  bool updateShouldNotify(CurrentPosition old) => position != old.position;
}