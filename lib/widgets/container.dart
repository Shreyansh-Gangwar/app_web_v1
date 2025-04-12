import 'package:flutter/material.dart';

class AppContainer extends StatelessWidget {
  final int height;
  final int width;
  final Widget child;
  const AppContainer({
    super.key,
    required this.height,
    required this.width,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: const Color(0x40000000),
              offset: Offset(5, 5),
              blurRadius: 15,
              spreadRadius: 0,
            ),
          ],
        ),
        height: height.toDouble(),
        width: width.toDouble(),
        child: child,
      ),
    );
  }
}
