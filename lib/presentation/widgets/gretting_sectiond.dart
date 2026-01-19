import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testtt/core/theme/colors_manager.dart';
import 'package:testtt/core/theme/text_styles.dart';
import 'package:testtt/presentation/cubits/user/user_cubit.dart';

/// Greeting Section Widget
/// Displays time-based greeting with emoji and username
class GreetingSection extends StatelessWidget {
  final String? username;

  const GreetingSection({super.key, this.username});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  String _getGreetingEmoji() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return '☀️';
    } else if (hour < 17) {
      return '👋';
    } else {
      return '🌙';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        String displayName = 'Guest';
        String? avatarPath;

        if (state is UserLoaded) {
          displayName = username ?? state.user.name ?? 'Guest';
          avatarPath = state.user.avatarPath;
        } else if (username != null) {
          displayName = username!;
        }

        final greeting = _getGreeting();
        final emoji = _getGreetingEmoji();

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        greeting,
                        style: TextStyles.heading2.copyWith(
                          color: ColorsManager.greycolor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Text(emoji, style: TextStyle(fontSize: 18.sp)),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    displayName,
                    style: TextStyles.heading1.copyWith(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w700,
                      color: ColorsManager.primaryDark,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),
            // Avatar
            GestureDetector(
              onTap: () {
                // Navigation handled by bottom bar usually, or we can push account screen
                // But this widget is in Home.
              },
              child: CircleAvatar(
                radius: 24.r,
                backgroundColor: ColorsManager.primary.withOpacity(0.1),
                backgroundImage:
                    avatarPath != null ? FileImage(File(avatarPath)) : null,
                child: avatarPath == null
                    ? Icon(Icons.person,
                        color: ColorsManager.primary, size: 24.sp)
                    : null,
              ),
            ),
          ],
        );
      },
    );
  }
}
