import 'package:flutter/material.dart';
import 'package:ytd/route.dart';
import 'package:ytd/theme/custom_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HTube Dl',
      theme: CustomTheme().dark,
      debugShowCheckedModeBanner: false,
      initialRoute: RouteGenerator.main,
      onGenerateRoute: (settings) => RouteGenerator.generateRoute(settings),
    );
  }
}
