import 'package:flutter/material.dart';
import 'package:ytd/route.dart';
import 'package:ytd/theme/custom_theme.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug:
          true, // optional: set to false to disable printing logs to console (default: true)
      ignoreSsl:
          true // option: set to false to disable working with http links (default: false)
      );

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
