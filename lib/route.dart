import 'package:flutter/material.dart';
import 'package:ytd/views/home_view.dart';

class RouteGenerator {
  static const String home = "./views/home_view.dart";

  RouteGenerator._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const MyHomePage());
      default:
        return MaterialPageRoute(builder: (_) => const MyHomePage());
    }
  }
}
