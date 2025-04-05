import 'dart:developer';

import 'package:app_web_v1/services/firebase_auth.dart';
import 'package:app_web_v1/services/firestore.dart';
import 'package:app_web_v1/utilities/colors.dart';
import 'package:app_web_v1/widgets/button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isLoggedIn = false;

  Map<String, dynamic>? userData = {};

  String userName = 'User';
  String joiningDate = 'N/A';
  Timestamp joiningDateTimestamp = Timestamp.now();
  int daysCount = 0;

  @override
  void initState() {
    super.initState();
    _initializeState();
  }

  Future<void> _initializeState() async {
    isLoggedIn = await AuthMethod().isLoggedIn();
    if (isLoggedIn) {
      userData = await Firestore().getUserData();
      userName = userData!['name'];
      joiningDateTimestamp = userData!['joiningDate'];
      joiningDate = joiningDateTimestamp.toDate().toString().split(' ')[0];
      log("Joining date: $joiningDate");
      daysCount =
          DateTime.now().difference(joiningDateTimestamp.toDate()).inDays;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isLoggedIn) {
      return Scaffold(
        body: Center(
          child: Text(
            'Please log in to view your profile.',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      );
    }
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Expanded(child: SizedBox()),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {},
                  color: AppColor.brand500,
                ),
                SizedBox(width: 20),
              ],
            ),
            SizedBox(height: 30),
            Row(
              children: [
                SizedBox(width: 50),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName, //USER NAME
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'Joined on ',
                        style: Theme.of(context).textTheme.labelSmall,
                        children: <TextSpan>[
                          TextSpan(
                            text: joiningDate,
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ],
                      ),
                    ), //JOIN DATE
                  ],
                ),
                Expanded(child: SizedBox()),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[200],
                    child: Image.asset(
                      isLoggedIn
                          ? userData!['profileImage'] ??
                              'assets/images/user.png'
                          : 'assets/images/user.png', //USER IMAGE
                      width: 55,
                    ), //USER IMAGE
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Divider(color: AppColor.brand500, thickness: 1),
            SizedBox(height: 35),
            SizedBox(
              width: 320,
              child: Text(
                textAlign: TextAlign.left,
                'Stats',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 35),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      isLoggedIn ? userData!['scannedCount'].toString() : '0',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Scanned',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      isLoggedIn ? userData!['savedCount'].toString() : '0',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Saved',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      isLoggedIn ? daysCount.toString() : '0',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 5),
                    Text('Days', style: Theme.of(context).textTheme.labelSmall),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Button(
              text: Text('Sign in (G)', style: TextStyle(color: Colors.white)),
              onTap: () async {
                await AuthMethod().signinwithGoogle(context);
                setState(() async {
                  isLoggedIn = await AuthMethod().isLoggedIn();
                  Firestore().initialDataSet();
                });
              },
            ),
            SizedBox(height: 20),
            Button(
              text: Text('Sign out (G)', style: TextStyle(color: Colors.white)),
              onTap: () async {
                await AuthMethod().signOut();
                setState(() async {
                  isLoggedIn = await AuthMethod().isLoggedIn();
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
