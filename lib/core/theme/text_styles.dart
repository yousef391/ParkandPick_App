import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testtt/core/theme/colors_manager.dart';
import 'package:testtt/core/theme/text_helper.dart';

class TextStyles {
  // HEADINGS
  static final TextStyle heading1 = GoogleFonts.roboto(
    fontSize: 28.sp,
    fontWeight: FontWeightHelper.bold,
    color: ColorsManager.blackcolor,
  );

  static final TextStyle heading2 = GoogleFonts.roboto(
    fontSize: 22.sp,
    fontWeight: FontWeightHelper.semibold,
    color: ColorsManager.blackcolor,
  );

  static final TextStyle sectionTitle = GoogleFonts.roboto(
    fontSize: 16.sp,
    fontWeight: FontWeightHelper.semibold,
    color: ColorsManager.blackcolor,
  );

  // BODY
  static final TextStyle body = GoogleFonts.roboto(
    fontSize: 16.sp,
    fontWeight: FontWeightHelper.normal,
    color: ColorsManager.blackcolor,
  );

  static final TextStyle bodyBold = GoogleFonts.roboto(
    fontSize: 16.sp,
    fontWeight: FontWeightHelper.semibold,
    color: ColorsManager.darkblue,
  );

  static final TextStyle hintText = GoogleFonts.roboto(
    fontSize: 15.sp,
    fontWeight: FontWeightHelper.normal,
    color: ColorsManager.textlightgrey,
  );

  static final TextStyle smallText = GoogleFonts.roboto(
    fontSize: 13.sp,
    fontWeight: FontWeightHelper.normal,
    color: ColorsManager.greycolor,
  );

  // BUTTONS
  static final TextStyle buttonText = GoogleFonts.roboto(
    fontSize: 16.sp,
    fontWeight: FontWeightHelper.semibold,
    color: ColorsManager.whitecolor,
  );

  static final TextStyle buttonTextPrimary = GoogleFonts.roboto(
    fontSize: 16.sp,
    fontWeight: FontWeightHelper.semibold,
    color: ColorsManager.primary,
  );

  // STATES
  static final TextStyle successText = GoogleFonts.roboto(
    fontSize: 15.sp,
    fontWeight: FontWeightHelper.medium,
    color: ColorsManager.greenColor,
  );

  static final TextStyle errorText = GoogleFonts.roboto(
    fontSize: 15.sp,
    fontWeight: FontWeightHelper.medium,
    color: ColorsManager.redAccent,
  );

  static final TextStyle warningText = GoogleFonts.roboto(
    fontSize: 15.sp,
    fontWeight: FontWeightHelper.medium,
    color: ColorsManager.warning,
  );

  static final TextStyle infoText = GoogleFonts.roboto(
    fontSize: 15.sp,
    fontWeight: FontWeightHelper.medium,
    color: ColorsManager.info,
  );
}
