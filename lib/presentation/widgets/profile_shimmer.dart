import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:testtt/core/theme/colors_manager.dart';

/// Shimmer loading widget that matches the AccountScreen layout structure
class ProfileShimmer extends StatelessWidget {
  const ProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    // Same dimensions as AccountScreen
    final double headerHeight = 240.h;
    final double sheetTop = 200.h;
    final double avatarSize = 100.w;
    final double avatarRadius = avatarSize / 2;
    final double avatarTop = sheetTop - avatarRadius;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        // --- 1. Red Header ---
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: headerHeight,
          child: Container(
            color: ColorsManager.primary,
            alignment: Alignment.topCenter,
            padding: EdgeInsets.only(top: 50.h),
            child: Text(
              'Profile',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),

        // --- 2. White Sheet ---
        Positioned(
          top: sheetTop,
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.r),
                topRight: Radius.circular(30.r),
              ),
            ),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Padding(
                padding:
                    EdgeInsets.fromLTRB(24.w, avatarRadius + 20.h, 24.w, 40.h),
                child: Column(
                  children: [
                    // Name placeholder
                    Container(
                      width: 150.w,
                      height: 24.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    // Email placeholder
                    Container(
                      width: 200.w,
                      height: 14.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                    ),
                    SizedBox(height: 32.h),
                    // Menu items
                    _buildMenuShimmer(),
                    _buildMenuShimmer(),
                    _buildMenuShimmer(),
                    _buildMenuShimmer(),
                    _buildMenuShimmer(),
                    SizedBox(height: 20.h),
                    Divider(color: Colors.grey.shade200),
                    SizedBox(height: 10.h),
                    // Logout
                    _buildMenuShimmer(),
                  ],
                ),
              ),
            ),
          ),
        ),

        // --- 3. Floating Avatar ---
        Positioned(
          top: avatarTop,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            padding: const EdgeInsets.all(4),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: CircleAvatar(
                radius: avatarSize / 2,
                backgroundColor: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuShimmer() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        children: [
          // Icon placeholder
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          SizedBox(width: 16.w),
          // Text placeholder
          Expanded(
            child: Container(
              height: 16.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ),
          SizedBox(width: 16.w),
          // Chevron placeholder
          Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
        ],
      ),
    );
  }
}
