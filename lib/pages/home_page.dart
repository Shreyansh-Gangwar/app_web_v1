import 'package:app_web_v1/utilities/colors.dart';
import 'package:app_web_v1/widgets/button.dart';
import 'package:app_web_v1/widgets/container.dart';
import 'package:app_web_v1/widgets/navbar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int page =
      1; // PAGE NUMBER FOR UPPER BAR 1. STATS 2. Scanned 3. AI Suggestion 4. Monthly Goal
  bool statsPage = true;
  bool scannedPage = false;
  bool aiSuggestionPage = false;
  bool monthlyGoalPage = false;
  @override
  Widget build(BuildContext context) {
    //=============================================== LOGIC ===================================================//
    setState(() {
      statsPage = page == 1;
      scannedPage = page == 2;
      aiSuggestionPage = page == 3;
      monthlyGoalPage = page == 4;
    });

    //=============================================== UI ===================================================//
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 80),
            Row(
              children: [
                Column(
                  children: [
                    SizedBox(
                      child: Text(
                        "Hey Shreyansh", //USER NAME
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 50.0),
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
            const SizedBox(height: 25),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SizedBox(width: 30),
                  Button(
                    text: Text(
                      'Stats',
                      style:
                          statsPage
                              ? Theme.of(context).textTheme.labelMedium
                              : Theme.of(context).textTheme.labelLarge,
                    ),
                    color: statsPage ? AppColor.brand500 : AppColor.bgcolor,
                    height: 32,
                    onTap: () {
                      setState(() {
                        page = 1;
                      });
                    },
                  ),
                  SizedBox(width: 10),
                  Button(
                    text: Text(
                      'Scanned',
                      style:
                          scannedPage
                              ? Theme.of(context).textTheme.labelMedium
                              : Theme.of(context).textTheme.labelLarge,
                    ),
                    color: scannedPage ? AppColor.brand500 : AppColor.bgcolor,
                    height: 32,
                    onTap: () {
                      setState(() {
                        page = 2;
                      });
                    },
                  ),
                  SizedBox(width: 10),
                  Button(
                    text: Text(
                      'AI Suggestion',
                      style:
                          aiSuggestionPage
                              ? Theme.of(context).textTheme.labelMedium
                              : Theme.of(context).textTheme.labelLarge,
                    ),
                    color:
                        aiSuggestionPage ? AppColor.brand500 : AppColor.bgcolor,
                    height: 32,
                    onTap: () {
                      setState(() {
                        page = 3;
                      });
                    },
                  ),
                  SizedBox(width: 10),
                  Button(
                    text: Text(
                      'Monthly Goal',
                      style:
                          monthlyGoalPage
                              ? Theme.of(context).textTheme.labelMedium
                              : Theme.of(context).textTheme.labelLarge,
                    ),
                    color:
                        monthlyGoalPage ? AppColor.brand500 : AppColor.bgcolor,
                    height: 32,
                    onTap: () {
                      setState(() {
                        page = 4;
                      });
                    },
                  ),
                  SizedBox(width: 30),
                ],
              ),
            ),
            // ======================= UI FOR STATS PAGE ========================//
            Column(
              children: [
                SizedBox(height: 28),
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
                          SizedBox(height: 80),
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
                          SizedBox(height: 20),
                          Text(
                            '1000/2500', //CALORIES
                            style: Theme.of(
                              context,
                            ).textTheme.titleLarge!.copyWith(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text('Calories'),
                          SizedBox(height: 100),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    '50',
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                  Text(
                                    'Protein',
                                    style:
                                        Theme.of(context).textTheme.labelSmall,
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    '50',
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                  Text(
                                    'Carbs',
                                    style:
                                        Theme.of(context).textTheme.labelSmall,
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    '50',
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                  Text(
                                    'Fats',
                                    style:
                                        Theme.of(context).textTheme.labelSmall,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              SizedBox(width: 50),
                              Text(
                                "Estrogenic Content:",
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                              SizedBox(width: 50),
                              Text(
                                'Low', //ESTROGENIC CONTENT
                                style: Theme.of(context).textTheme.labelSmall!
                                    .copyWith(color: AppColor.brand500),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.only(left: 50.0),
                  child: Row(
                    children: [
                      Text(
                        'Last Scanned',
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Stack(
                  children: [
                    Center(
                      child: Column(
                        children: [SizedBox(height: 100), NavBar(page: 1)],
                      ),
                    ),
                    Center(
                      child: AppContainer(
                        height: 95,
                        width: 355,
                        child: Column(
                          children: [
                            SizedBox(height: 18),
                            Row(
                              children: [
                                SizedBox(width: 30),
                                Text(
                                  "Apple Pie", //FOOD NAME
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 12.0),
                                    child: Text(
                                      textAlign: TextAlign.end,
                                      '200cal', //CALORIES
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall!
                                          .copyWith(color: AppColor.brand500),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Divider(color: Colors.grey[250], thickness: 1),
                            Row(
                              children: [
                                SizedBox(width: 30),
                                Text(
                                  "Daal Chawal", //FOOD NAME
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 12.0),
                                    child: Text(
                                      textAlign: TextAlign.end,
                                      '400cal', //CALORIES
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall!
                                          .copyWith(color: AppColor.brand500),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
