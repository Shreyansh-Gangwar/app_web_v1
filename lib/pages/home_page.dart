import 'dart:ffi';

import 'package:app_web_v1/pages/splash_screen.dart';
import 'package:app_web_v1/services/firestore.dart';
import 'package:app_web_v1/utilities/colors.dart';
import 'package:app_web_v1/utilities/routes.dart';
import 'package:app_web_v1/widgets/button.dart';
import 'package:app_web_v1/widgets/container.dart';
import 'package:app_web_v1/widgets/navbar.dart';
import 'package:app_web_v1/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

enum PageType { stats, scanned, aiSuggestion }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageType currentPage = PageType.stats;
  bool isLoggedIn = SplashScreen.isLoggedIn;
  Map<String, dynamic>? userData;
  Map<String, dynamic>? dailyData;
  bool isCopied = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userData = Provider.of<Firestore>(context).userData;
    dailyData = Provider.of<Firestore>(context).dailyData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 90),
          _buildHeader(context),
          const SizedBox(height: 25),
          _buildPageSelector(context),
          Expanded(child: _buildPageContent(context)),
          NavBar(page: 1),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isLoggedIn && userData != null && userData!.containsKey('name')
                    ? "Hey ${userData!['name']}"
                    : "Hey User",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                'Start your day with a healthy meal!',
                style: Theme.of(
                  context,
                ).textTheme.labelSmall!.copyWith(fontSize: 14),
              ),
            ],
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.only(right: 30.0),
          child: InkWell(
            onTap: () => Navigator.of(context).pushNamed(AppRoutes.profile),
            child: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.grey[200],
              child: Image.asset('assets/images/user.png', width: 35),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPageSelector(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          const SizedBox(width: 30),
          _buildPageButton(context, 'Stats', PageType.stats),
          const SizedBox(width: 10),
          _buildPageButton(context, 'Scanned', PageType.scanned),
          const SizedBox(width: 10),
          _buildPageButton(context, 'AI Suggestion', PageType.aiSuggestion),
          const SizedBox(width: 30),
        ],
      ),
    );
  }

  Widget _buildPageButton(BuildContext context, String title, PageType page) {
    final isSelected = currentPage == page;
    return Button(
      text: Text(
        title,
        style:
            isSelected
                ? Theme.of(context).textTheme.labelMedium
                : Theme.of(context).textTheme.labelLarge,
      ),
      color: isSelected ? AppColor.brand500 : Colors.white,
      height: 32,
      onTap: () => setState(() => currentPage = page),
    );
  }

  Widget _buildPageContent(BuildContext context) {
    switch (currentPage) {
      case PageType.stats:
        return _buildStatsPage(context);
      case PageType.scanned:
        return _buildScannedPage(context);
      case PageType.aiSuggestion:
        return _buildAISuggestionPage(context);
    }
  }

  Widget _buildStatsPage(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 28),
          AppContainer(
            height: 420,
            width: 340,
            child: Stack(
              children: [
                Column(
                  children: [
                    const SizedBox(height: 40),
                    Center(
                      child: SizedBox(
                        height: 214,
                        width: 214,
                        child: CircularProgressIndicator(
                          strokeWidth: 18,
                          backgroundColor: const Color(0xfff3edea),
                          valueColor: AlwaysStoppedAnimation(AppColor.brand500),
                          value:
                              ((dailyData?['caloriesConsumed'] ?? 0)
                                  .toDouble()) /
                              ((userData?['dailyCalories'] ?? 2000).toDouble()),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const SizedBox(height: 90),
                    Center(
                      child: Text(
                        'Today',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: AppColor.neutral900,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      '${dailyData?['caloriesConsumed'] ?? ' 0'}/${userData?['dailyCalories'] ?? '2000'}',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Text('Calories'),
                    const SizedBox(height: 110),
                    _buildNutrientRow(context),
                    const SizedBox(height: 30),
                    _buildEstrogenicContentRow(context),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          _buildLastScannedSection(context),
        ],
      ),
    );
  }

  Widget _buildNutrientRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildNutrientColumn(
          context,
          dailyData?['protien'].toString() ?? '0',
          'Protein',
        ),
        _buildNutrientColumn(
          context,
          dailyData?['carbs'].toString() ?? '0',
          'Carbs',
        ),
        _buildNutrientColumn(
          context,
          dailyData?['fat'].toString() ?? '0',
          'Fats',
        ),
      ],
    );
  }

  Widget _buildNutrientColumn(
    BuildContext context,
    String value,
    String label,
  ) {
    return Column(
      children: [
        Text(value, style: Theme.of(context).textTheme.titleLarge),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }

  Widget _buildEstrogenicContentRow(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 50),
        Text(
          "Estrogenic Content:",
          style: Theme.of(context).textTheme.labelSmall,
        ),
        const SizedBox(width: 50),
        Text(
          'Low',
          style: Theme.of(
            context,
          ).textTheme.labelSmall!.copyWith(color: AppColor.brand500),
        ),
      ],
    );
  }

  Widget _buildLastScannedSection(BuildContext context) {
    return Column(
      children: [
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
        const SizedBox(height: 20),
        Center(
          child: AppContainer(
            height: 95,
            width: 355,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildScannedItem(context, "Apple Pie", "200cal"),
                SizedBox(height: 5),
                Divider(color: Colors.grey[250], thickness: 1),
                SizedBox(height: 5),
                _buildScannedItem(context, "Daal Chawal", "400cal"),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScannedItem(BuildContext context, String name, String calories) {
    return Row(
      children: [
        const SizedBox(width: 30),
        Text(name, style: Theme.of(context).textTheme.labelSmall),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: Text(
            calories,
            style: Theme.of(
              context,
            ).textTheme.labelSmall!.copyWith(color: AppColor.brand500),
          ),
        ),
      ],
    );
  }

  Widget _buildScannedPage(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 50),
          SizedBox(
            width: 320,
            child: Text(
              'Last Scanned',
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(height: 20),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 7,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  AppContainer(
                    height: 90,
                    width: 350,
                    child: Row(
                      children: [
                        const SizedBox(width: 25),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 27),
                            Text(
                              "Apple Pie",
                              style: Theme.of(
                                context,
                              ).textTheme.titleLarge!.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              "Mildly Estrogenic",
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColor.brand500,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: Text(
                            '200cal',
                            style: Theme.of(
                              context,
                            ).textTheme.labelMedium!.copyWith(
                              color: AppColor.brand500,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAISuggestionPage(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 50),
        SizedBox(
          width: 320,
          child: Text(
            'AI Suggestions',
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const SizedBox(height: 20),
        AppContainer(
          height: 350,
          width: 350,
          child: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Image.asset('assets/images/AI.png', width: 50),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text('Apple Pie'),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Button(
          text: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(isCopied ? Icons.check : Icons.copy, color: Colors.white),
              const SizedBox(width: 10),
              Text(
                isCopied ? 'Copied' : 'Copy to clipboard',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
          width: 200,
          onTap: () {
            Clipboard.setData(const ClipboardData(text: "Apple Pie"));
            showSnackBar(context, "Text has been copied to clipboard");
            setState(() => isCopied = true);
            Future.delayed(const Duration(seconds: 5), () {
              setState(() => isCopied = false);
            });
          },
        ),
      ],
    );
  }
}
