import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testtt/core/theme/colors_manager.dart';
import 'package:testtt/core/theme/text_styles.dart';

class TextFieldWidget extends StatelessWidget {
  final String hintText;
  final bool? obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? hintStyle;
  final TextStyle? inputTextStyle;
  final OutlineInputBorder? focusedBorder;
  final OutlineInputBorder? enabledBorder;
  final Color? backgroundColor;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const TextFieldWidget({
    super.key,
    required this.hintText,
    this.obscureText,
    this.suffixIcon,
    this.prefixIcon,
    this.contentPadding,
    this.hintStyle,
    this.inputTextStyle,
    this.focusedBorder,
    this.enabledBorder,
    this.backgroundColor,
    this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      cursorColor: ColorsManager.primary,
      style: inputTextStyle ?? TextStyles.body.copyWith(color: Colors.black),
      obscureText: obscureText ?? false,
      decoration: InputDecoration(
        filled: true,
        fillColor: backgroundColor ?? ColorsManager.textfieldcolor,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        hintStyle: hintStyle ?? TextStyles.hintText,
        hintText: hintText,
        isDense: true,
        contentPadding: contentPadding ??
            EdgeInsets.symmetric(vertical: 18.h, horizontal: 20.w),
        focusedBorder: focusedBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: const BorderSide(
                color: ColorsManager.primary,
                width: 1.3,
              ),
            ),
        enabledBorder: enabledBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: const BorderSide(
                color: ColorsManager.textfieldbordercolor,
                width: 1.3,
              ),
            ),
      ),
    );
  }
}
