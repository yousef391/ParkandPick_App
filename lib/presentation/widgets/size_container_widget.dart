import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testtt/core/theme/colors_manager.dart';
import 'package:testtt/core/theme/text_styles.dart';

class SizeContainerWidget extends StatelessWidget {
  const SizeContainerWidget({
    super.key,
    required this.isSelected,
    required this.size,
    required this.ontap,
  });
  final bool isSelected;
  final String size;
  final VoidCallback ontap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        height: 48.h,
        constraints: BoxConstraints(minWidth: 80.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: isSelected
              ? ColorsManager.selectedSizeBox
              : ColorsManager.textfieldcolor,
          border: Border.all(
            color: isSelected
                ? ColorsManager.primary
                : ColorsManager.textfieldbordercolor,
            width: isSelected ? 2 : 1.5,
          ),
        ),
        child: Center(
          child: Text(
            size,
            style: TextStyles.smallText.copyWith(
              color: isSelected
                  ? ColorsManager.primary
                  : ColorsManager.blackcolor,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
