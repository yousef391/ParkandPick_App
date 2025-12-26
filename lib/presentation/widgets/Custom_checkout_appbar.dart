import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testtt/core/theme/colors_manager.dart';
import 'package:testtt/core/theme/text_styles.dart';

class CustomAppBAr extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBAr({super.key});

  @override
  Size get preferredSize => Size.fromHeight(60.h);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ColorsManager.whitecolor,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: ColorsManager.primaryDark,
          size: 20.sp,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Checkout',
        style: TextStyles.heading2.copyWith(
          fontSize: 18.sp,
          color: ColorsManager.primaryDark,
        ),
      ),
      centerTitle: true,
    );
  }
}
