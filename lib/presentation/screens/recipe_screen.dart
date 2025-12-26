import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testtt/core/theme/colors_manager.dart';
import 'package:testtt/core/theme/text_styles.dart';

class RecipeScreen extends StatelessWidget {
  const RecipeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final steps = [
      'Grind fresh beans to medium-fine.',
      'Heat water to 93°C.',
      'Add 18g coffee to filter.',
      'Pour 40g water, bloom 30s.',
      'Slowly pour to 300g total over 2:30.',
      'Serve and enjoy.',
    ];
    final ingredients = [
      '18g fresh coffee beans',
      '300g filtered water',
      'Paper filter',
      'Gooseneck kettle',
    ];

    return Scaffold(
      backgroundColor: ColorsManager.whitecolor,
      appBar: AppBar(
        backgroundColor: ColorsManager.whitecolor,
        elevation: 0,
        title: Text(
          'Brew Recipe',
          style: TextStyles.heading2.copyWith(
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: Image.asset(
                'assets/images/nathan-dumlao-dAYJfrtVjh0-unsplash.jpg',
                height: 220.h,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'Pour-over Signature',
              style: TextStyles.heading1.copyWith(fontSize: 26.sp),
            ),
            SizedBox(height: 8.h),
            Text(
              'Clean, sweet cup with balanced body. Great for single-origin beans.',
              style: TextStyles.body.copyWith(
                color: ColorsManager.greycolor,
                fontSize: 15.sp,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'Ingredients',
              style: TextStyles.heading2.copyWith(fontSize: 18.sp),
            ),
            SizedBox(height: 12.h),
            ...ingredients.map(
              (item) => Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: ColorsManager.primary, size: 18.sp),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        item,
                        style: TextStyles.body,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'Steps',
              style: TextStyles.heading2.copyWith(fontSize: 18.sp),
            ),
            SizedBox(height: 12.h),
            ...steps.asMap().entries.map(
              (entry) => Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 28.w,
                      height: 28.w,
                      decoration: BoxDecoration(
                        color: ColorsManager.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${entry.key + 1}',
                        style: TextStyles.bodyBold.copyWith(
                          color: ColorsManager.primary,
                          fontSize: 13.sp,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(
                        entry.value,
                        style: TextStyles.body,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}

