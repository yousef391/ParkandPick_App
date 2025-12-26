import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testtt/core/constants/text_manager.dart';
import 'package:testtt/core/theme/colors_manager.dart';
import 'package:testtt/core/theme/text_styles.dart';

class ButtonWidget extends StatelessWidget {
  final String? title;
  final VoidCallback onTap;
  final BorderRadius? borderRadius;
  final double? width;
  final double? height;
  final Color? color;

  const ButtonWidget({
    super.key,
    this.title,
    required this.onTap,
    this.width,
    this.height,
    this.borderRadius,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 48.h,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? ColorsManager.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(16.r),
          ),
          animationDuration: const Duration(milliseconds: 200),
          elevation: 0,
        ),
        child: Text(
          title ?? TextManager.loginButton,
          style: TextStyles.buttonText,
        ),
      ),
    );
  }
}
