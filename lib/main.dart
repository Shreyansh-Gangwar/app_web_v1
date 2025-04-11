import 'package:app_web_v1/firebase_options.dart';
import 'package:app_web_v1/pages/AI_page.dart';
import 'package:app_web_v1/pages/profile_page.dart';
import 'package:app_web_v1/pages/splash_screen.dart';
import 'package:app_web_v1/services/firestore.dart';
import 'package:app_web_v1/utilities/routes.dart';
import 'package:app_web_v1/utilities/theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'pages/home_page.dart';
import 'package:provider/provider.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  final apiKey = dotenv.env['GOOGLE_API_KEY'];
  final model = GenerativeModel(model: '', apiKey: apiKey ?? 'default_api_key');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => Firestore())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Web V1',
      theme: AppTheme.lightTheme(context),

      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      initialRoute: '/',
      routes: {
        AppRoutes.home: (context) => const HomePage(),
        AppRoutes.profile: (context) => const ProfilePage(),
        AppRoutes.ai: (context) => const AiPage(),
      },
    );
  }
}
