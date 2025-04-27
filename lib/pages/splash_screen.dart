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
  static Map<String, dynamic>? get dailyData => _SplashScreenState.dailyData;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static bool isLoggedIn = false;
  static Map<String, dynamic>? userData;
  static Map<String, dynamic>? dailyData;

  @override
  void initState() {
    super.initState();
    _initializeState();
  }

  _initializeState() async {
    isLoggedIn = await AuthMethod().isLoggedIn();
    if (isLoggedIn) {
      Provider.of<Firestore>(context, listen: false).initListeners();

      Future.delayed(const Duration(seconds: 2), () {
        // Navigate to the home screen after the delay
        Navigator.of(context).pushReplacementNamed(AppRoutes.home);
      });
      Firestore().addDailycaloriesCollection();
    } else {
      userData = null;

      log(userData.toString());

      Future.delayed(const Duration(seconds: 2), () {
        Navigator.of(context).pushReplacementNamed(AppRoutes.login);
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
            const SizedBox(height: 100),
            CircleAvatar(
              backgroundImage: AssetImage('assets/images/logo/logo.png'),
              maxRadius: 75,
            ), // LOGO GOES HERE
            const SizedBox(height: 250),
            SpinKitThreeBounce(size: 25.0, color: AppColor.brand500),
          ],
        ),
      ),
    );
  }
}
