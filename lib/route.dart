import 'package:flutter/material.dart';
import 'package:ytd/views/main_view.dart';

class RouteGenerator {
  static const String main = "./views/main_view.dart";
  // static const String home = "./views/home_view.dart";

  RouteGenerator._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case main:
        return MaterialPageRoute(builder: (_) => MainView());
      default:
        return MaterialPageRoute(builder: (_) => MainView());
    }
  }
}
