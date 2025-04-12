import 'package:app_web_v1/pages/splash_screen.dart';
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
  final FocusNode _caloriesFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _initializeState();
    _caloriesFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _caloriesFocusNode.dispose();
    super.dispose();
  }

  Future<void> _initializeState() async {
    isLoggedIn = await AuthMethod().isLoggedIn();
    if (isLoggedIn) {
      userData = SplashScreen.userData;
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
      body: Center(child: isLoggedIn ? _buildProfileContent() : _buildSignIn()),
    );
  }

  Widget _buildProfileContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        Padding(
          padding: const EdgeInsets.only(left: 50.0),
          child: Text(
            'Your Stats',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        const SizedBox(height: 40),
        _buildStats(),
        const SizedBox(height: 40),
        _buildDailyCalories(),
        const SizedBox(height: 20),
        Center(
          child: Button(
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
        ),
        SizedBox(height: 20),
        Center(
          child: Button(
            text: const Text(
              'AI Page [temp]',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () => Navigator.of(context).pushNamed(AppRoutes.ai),
          ),
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

  Widget _buildDailyCalories() {
    return Row(
      children: [
        const SizedBox(width: 50),
        // Label for daily calories
        Text(
          'Daily Calories',
          style: Theme.of(
            context,
          ).textTheme.labelSmall!.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 20),
        // Input field for daily calories
        SizedBox(
          width: 45,
          child: TextField(
            controller: TextEditingController(
              text: userData?['dailyCalories']?.toString() ?? '2000',
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              // Update daily calories in Firestore
              Firestore().updateUserData(
                'dailyCalories',
                int.tryParse(value) ?? 2000,
              );
              SplashScreen.userData?['dailyCalories'] =
                  int.tryParse(value) ?? 2000;
            },
            focusNode: _caloriesFocusNode,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.only(bottom: 2),
              hintText: '2000',
              hintStyle: Theme.of(context).textTheme.labelLarge!.copyWith(
                color:
                    _caloriesFocusNode.hasFocus
                        ? Colors.grey
                        : AppColor.brand500,
              ),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.orange),
              ),
            ),
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
      ],
    );
  }

  Widget _buildSignIn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Please sign in to view your profile'),
        const SizedBox(height: 20),
        Button(
          text: const Text(
            'Sign in with Google',
            style: TextStyle(color: Colors.white),
          ),
          onTap: () async {
            await AuthMethod().signinwithGoogle(context);
            setState(() {
              isLoggedIn = true;
              _initializeState();
            });
          },
        ),
      ],
    );
  }
}
