import 'dart:developer';

import 'package:app_web_v1/services/firebase_auth.dart';
import 'package:app_web_v1/services/firestore.dart';
import 'package:app_web_v1/utilities/colors.dart';
import 'package:app_web_v1/utilities/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static bool get isLoggedIn => _SplashScreenState.isLoggedIn;
  static Map<String, dynamic>? get userData => _SplashScreenState.userData;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static bool isLoggedIn = false;
  static Map<String, dynamic>? userData;

  void initState() {
    super.initState();
    _initializeState();
  }

  _initializeState() async {
    isLoggedIn = await AuthMethod().isLoggedIn();
    if (isLoggedIn) {
      Provider.of<Firestore>(context, listen: false).fetchUserData().then((_) {
        userData = Provider.of<Firestore>(context, listen: false).userData;
      });
      log(userData.toString());
      Future.delayed(const Duration(seconds: 2), () {
        // Navigate to the home screen after the delay
        Navigator.of(context).pushReplacementNamed(AppRoutes.home);
      });
    } else {
      userData = null;
      log(userData.toString());
      Future.delayed(const Duration(seconds: 2), () {
        // Navigate to the login screen after the delay
        Navigator.of(context).pushReplacementNamed(AppRoutes.home);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to App Web V1',
              style: Theme.of(context).textTheme.titleLarge,
            ), // LOGO GOES HERE
            const SizedBox(height: 20),
            SpinKitPulse(color: AppColor.brand500),
          ],
        ),
      ),
    );
  }
}
