import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testtt/core/theme/colors_manager.dart';

class CustomIconbutton extends StatelessWidget {
  const CustomIconbutton({
    super.key,
    this.backgorundColor,
    required this.icon,
    required this.ontap,
  });
  final Color? backgorundColor;
  final VoidCallback ontap;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Container(
        height: 40.h,
        width: 40.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgorundColor ?? ColorsManager.greycolor.withOpacity(0.2),
        ),
        child: Center(child: icon),
      ),
    );
  }
}
