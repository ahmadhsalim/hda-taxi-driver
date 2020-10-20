import 'package:get_it/get_it.dart';
import 'package:hda_app/services/identity-service.dart';
import 'package:hda_app/services/trip-service.dart';

GetIt getIt = GetIt.instance;

setupServiceLocator() {
  getIt.registerSingleton<Identity>(Identity());
  getIt.registerSingleton<TripService>(TripService());
}