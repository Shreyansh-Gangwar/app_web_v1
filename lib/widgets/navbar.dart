import 'package:app_web_v1/utilities/colors.dart';
import 'package:app_web_v1/utilities/routes.dart';
import 'package:flutter/material.dart';

class NavBar extends StatefulWidget {
  final int page; // 1 = home, 2 = profile
  const NavBar({super.key, required this.page});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    bool homeCheck = true;
    bool profileCheck = false;

    if (widget.page == 1) {
      setState(() {
        homeCheck = true;
        profileCheck = false;
      });
    } else if (widget.page == 2) {
      setState(() {
        homeCheck = false;
        profileCheck = true;
      });
    }

    return Material(
      child: BottomNavigationBar(
        elevation: 0,
        items: [
          BottomNavigationBarItem(
            icon: InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(AppRoutes.home);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(width: 10),
                  homeCheck
                      ? Column(
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
                      )
                      : Text(
                        'Home',
                        style: TextStyle(
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
              onTap: () {
                Navigator.of(context).pushNamed(AppRoutes.profile);
              },
              child: Row(
                children: [
                  const SizedBox(height: 0, width: 20),
                  profileCheck
                      ? Column(
                        children: [
                          Text(
                            'Profile',
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
                      )
                      : Text(
                        'Profile',
                        style: TextStyle(
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
