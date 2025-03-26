import 'package:flutter/material.dart';
import 'package:app_web_v1/utilities/colors.dart';

class Button extends StatelessWidget {
  final Color? color;
  final double? height;
  final double? width;
  final double? radius;
  final Widget text;
  const Button({
    super.key,
    this.color,
    this.height,
    this.width,
    required this.text,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    bool colorCheck = false;
    bool heightCheck = false;
    bool widthCheck = false;
    bool radiusCheck = false;

    if (color != null) {
      colorCheck = true;
    }
    if (height != null) {
      heightCheck = true;
    }
    if (width != null) {
      widthCheck = true;
    }
    if (radius != null) {
      radiusCheck = true;
    }
    return Material(
      color: colorCheck ? color : AppColor.brand500,
      borderRadius:
          radiusCheck
              ? BorderRadius.circular(radius as double)
              : BorderRadius.circular(25),
      child: InkWell(
        onTap: () {},
        child: Container(
          height: heightCheck ? height : 50,
          width: widthCheck ? width : 150,
          decoration: BoxDecoration(
            border: Border.all(color: AppColor.brand500, width: 1.0),
            borderRadius:
                radiusCheck
                    ? BorderRadius.circular(radius as double)
                    : BorderRadius.circular(25),
          ),
          alignment: Alignment.center,
          child: text,
        ),
      ),
    );
  }
}
