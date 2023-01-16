import 'package:flutter/material.dart';
import 'package:ytd/route.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HTube Dl',
      theme: ThemeData.dark(
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: RouteGenerator.home,
      onGenerateRoute: (settings) => RouteGenerator.generateRoute(settings),
    );
  }
}
