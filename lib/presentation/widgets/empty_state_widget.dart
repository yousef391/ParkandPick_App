import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testtt/core/theme/colors_manager.dart';
import 'package:testtt/core/theme/text_styles.dart';

/// Empty State Widget
/// Shows when no products are found (search or filter)
class EmptyStateWidget extends StatelessWidget {
  final bool hasSearch;
  final bool hasFilter;
  final VoidCallback? onClearFilters;

  const EmptyStateWidget({
    super.key,
    this.hasSearch = false,
    this.hasFilter = false,
    this.onClearFilters,
  });

  @override
  Widget build(BuildContext context) {
    final showClearButton = hasSearch || hasFilter;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120.w,
            height: 120.h,
            decoration: BoxDecoration(
              color: ColorsManager.softGrey.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.coffee_outlined,
              size: 60.sp,
              color: ColorsManager.greycolor.withOpacity(0.6),
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            hasSearch ? 'No results found' : 'No products available',
            style: TextStyles.heading2.copyWith(
              color: ColorsManager.primaryDark,
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: Text(
              hasSearch
                  ? 'Try searching for something else'
                  : 'Check back later for new products',
              style: TextStyles.body.copyWith(
                color: ColorsManager.greycolor,
                fontSize: 14.sp,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          if (showClearButton && onClearFilters != null) ...[
            SizedBox(height: 24.h),
            TextButton(
              onPressed: onClearFilters,
              style: TextButton.styleFrom(
                backgroundColor: ColorsManager.primary.withOpacity(0.1),
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                'Clear Filters',
                style: TextStyles.body.copyWith(
                  color: ColorsManager.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
