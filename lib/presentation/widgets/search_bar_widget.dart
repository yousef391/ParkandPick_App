import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testtt/core/theme/colors_manager.dart';
import 'package:testtt/core/theme/text_styles.dart';

/// Search Bar Widget
/// Reusable search input with active state styling
class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final String searchQuery;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final String hintText;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.searchQuery,
    required this.onChanged,
    required this.onClear,
    this.hintText = 'Search coffee...',
  });

  @override
  Widget build(BuildContext context) {
    final isActive = searchQuery.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: ColorsManager.textfieldcolor,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: isActive
              ? ColorsManager.primary.withOpacity(0.3)
              : ColorsManager.textfieldbordercolor,
          width: 1.5,
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: ColorsManager.primary.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: TextStyles.body.copyWith(
          fontSize: 15.sp,
          color: ColorsManager.primaryDark,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyles.hintText.copyWith(fontSize: 15.sp),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: isActive ? ColorsManager.primary : ColorsManager.greycolor,
            size: 22.sp,
          ),
          suffixIcon: isActive
              ? IconButton(
                  icon: Icon(
                    Icons.clear_rounded,
                    color: ColorsManager.greycolor,
                    size: 20.sp,
                  ),
                  onPressed: onClear,
                  splashRadius: 20,
                )
              : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 16.h,
          ),
        ),
      ),
    );
  }
}
