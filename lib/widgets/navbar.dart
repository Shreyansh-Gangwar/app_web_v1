import 'package:app_web_v1/utilities/colors.dart';
import 'package:flutter/material.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: BottomNavigationBar(
        elevation: 0,
        items: [
          BottomNavigationBarItem(
            icon: Row(
              children: [
                const SizedBox(height: 0, width: 60),
                Column(
                  children: [
                    Text(
                      'Home',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium!.copyWith(fontSize: 20),
                    ),
                    Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                        color: AppColor.brand500,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: InkWell(
              onTap: () {}, // Add the route name
              child: Container(
                height: 64,
                width: 64,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(32)),
                  color: AppColor.brand500,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.5),
                  child: (Image.asset('assets/images/scanner.png')),
                ),
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: InkWell(
              onTap: () {}, // Add the route name
              child: Row(
                children: [
                  const SizedBox(height: 0, width: 20),
                  Text(
                    'Profile',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 20,
                      color: const Color(0xFF6B564D),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}
