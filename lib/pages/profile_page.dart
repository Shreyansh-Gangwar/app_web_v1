import 'package:app_web_v1/services/firebase_auth.dart';
import 'package:app_web_v1/services/firestore.dart';
import 'package:app_web_v1/utilities/colors.dart';
import 'package:app_web_v1/utilities/routes.dart';
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
      if (userData != null) {
        userName = userData!['name'];
        Timestamp joiningDateTimestamp = userData!['joiningDate'];
        joiningDate = joiningDateTimestamp.toDate().toString().split(' ')[0];
        daysCount =
            DateTime.now().difference(joiningDateTimestamp.toDate()).inDays;
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isLoggedIn ? _buildProfileContent() : _buildSignInButton(),
      ),
    );
  }

  Widget _buildProfileContent() {
    return Column(
      children: [
        const SizedBox(height: 50),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new),
                onPressed: () => Navigator.pop(context),
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {},
                color: AppColor.brand500,
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        Row(
          children: [
            const SizedBox(width: 50),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(userName, style: Theme.of(context).textTheme.titleLarge),
                RichText(
                  text: TextSpan(
                    text: 'Joined on ',
                    style: Theme.of(context).textTheme.labelSmall,
                    children: [
                      TextSpan(
                        text: joiningDate,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.grey[200],
              child: Image.asset(
                userData?['profileImage'] ?? 'assets/images/user.png',
                width: 55,
              ),
            ),
            SizedBox(width: 25),
          ],
        ),
        const SizedBox(height: 20),
        Divider(color: AppColor.brand500, thickness: 1),
        const SizedBox(height: 35),
        _buildStats(),
        const SizedBox(height: 20),
        Button(
          text: const Text(
            'Sign out (G)',
            style: TextStyle(color: Colors.white),
          ),
          onTap: () async {
            await AuthMethod().signOut();
            setState(() {
              isLoggedIn = false;
              userData = null;
            });
          },
        ),
        SizedBox(height: 20),
        Button(
          text: const Text(
            'AI Page [temp]',
            style: TextStyle(color: Colors.white),
          ),
          onTap: () => Navigator.of(context).pushNamed(AppRoutes.ai),
        ),
      ],
    );
  }

  Widget _buildStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatItem(userData?['scannedCount']?.toString() ?? '0', 'Scanned'),
        _buildStatItem(userData?['savedCount']?.toString() ?? '0', 'Saved'),
        _buildStatItem(daysCount.toString(), 'Days'),
      ],
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(value, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 5),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }

  Widget _buildSignInButton() {
    return Button(
      text: const Text('Sign in (G)', style: TextStyle(color: Colors.white)),
      onTap: () async {
        await AuthMethod().signinwithGoogle(context);
        _initializeState();
      },
    );
  }
}
