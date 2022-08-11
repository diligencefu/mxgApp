import 'package:flutter/material.dart';
import 'package:flutter_quick/constants/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppButton extends StatelessWidget {
  final String title;
  final double? width;
  final double? borderRadius;
  final Color? bgColor;
  final Color? borderColor;
  final Color? textColor;
  final double? height;
  final double? fontSize;
  final GestureTapCallback? onTap;

  const AppButton({
    Key? key,
    required this.title,
    this.width,
    this.height,
    this.bgColor,
    this.borderColor,
    this.borderRadius,
    this.textColor,
    this.fontSize,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 375.w,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onTap,
        child: Container(
          height: height ?? 60.w,
          decoration: BoxDecoration(
            color: bgColor ?? ColorConstants.appColor,
            borderRadius: BorderRadius.all(
              Radius.circular(borderRadius ?? 100.0),
            ),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: textColor ?? Colors.white,
                fontSize: fontSize ?? 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
