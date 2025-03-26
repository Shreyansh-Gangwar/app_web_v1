import 'package:app_web_v1/utilities/colors.dart';
import 'package:app_web_v1/widgets/button.dart';
import 'package:app_web_v1/widgets/container.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 100),
            Row(
              children: [
                Column(
                  children: [
                    Text(
                      "Hey Shreyansh", //USER NAME
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 55.0),
                      child: Text(
                        'Start your day with a healthy meal !',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 30),
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.grey[200],
                  child: Image.asset(
                    'assets/images/user.png',
                    width: 35,
                  ), //USER IMAGE
                ),
              ],
            ),
            const SizedBox(height: 35),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SizedBox(width: 30),
                  Button(
                    text: Text(
                      'Stats',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    color: AppColor.brand500,
                    height: 32,
                  ),
                  SizedBox(width: 10),
                  Button(
                    text: Text(
                      'Scanned',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    color: AppColor.bgcolor,
                    height: 32,
                  ),
                  SizedBox(width: 10),
                  Button(
                    text: Text(
                      'AI Suggestion',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    color: AppColor.bgcolor,
                    height: 32,
                  ),
                  SizedBox(width: 10),
                  Button(
                    text: Text(
                      'Monthly Goal',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    color: AppColor.bgcolor,
                    height: 32,
                  ),
                  SizedBox(width: 30),
                ],
              ),
            ),
            SizedBox(height: 38),
            AppContainer(
              height: 420,
              width: 340,
              child: Stack(
                children: [
                  //PROGRESS WHEEL
                  Column(
                    children: [
                      SizedBox(height: 40),
                      Center(
                        child: SizedBox(
                          height: 214,
                          width: 214,
                          child: CircularProgressIndicator(
                            strokeWidth: 18,
                            backgroundColor: Color(0xfff3edea),
                            valueColor: AlwaysStoppedAnimation(
                              AppColor.brand500,
                            ),
                            value: .42, //HERE WILL BE THE FIREBASE DATA
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(height: 90),
                      Center(
                        child: Text(
                          'Today', //DATE
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color: AppColor.neutral900,
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        '1000/2500', //CALORIES
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text('Calories'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
