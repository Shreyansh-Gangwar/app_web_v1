import 'package:app_web_v1/firebase_options.dart';
import 'package:app_web_v1/utilities/theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Web V1',
      theme: AppTheme.lightTheme(context),

      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
