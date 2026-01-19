import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testtt/core/theme/colors_manager.dart';
import 'package:testtt/core/theme/text_styles.dart';
import 'package:testtt/presentation/cubits/auth/auth_cubit.dart';
import 'package:testtt/presentation/cubits/user/user_cubit.dart';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:image_picker/image_picker.dart';
import 'package:testtt/presentation/widgets/profile_shimmer.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  File? _pendingAvatar;

  @override
  void initState() {
    super.initState();
    context.read<UserCubit>().loadCurrentUser();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    final userCubit = context.read<UserCubit>();
    await userCubit.updateProfile(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
    );
    if (_pendingAvatar != null) {
      await userCubit.uploadAvatar(_pendingAvatar!);
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      final imageFile = File(file.path);
      setState(() {
        _pendingAvatar = imageFile;
      });
      context.read<UserCubit>().uploadAvatar(imageFile);
    }
  }

  ImageProvider? _getAvatarImage(String? path) {
    final displayPath = _pendingAvatar?.path ?? path;
    if (displayPath == null || displayPath.isEmpty) return null;
    if (displayPath.startsWith('http')) {
      return NetworkImage(displayPath);
    }
    return FileImage(File(displayPath));
  }

  @override
  Widget build(BuildContext context) {
    // 1. Define Brand Color (Red) from ColorsManager
    const headerColor = ColorsManager.primary;

    // Dimensions
    final double headerHeight = 240.h;
    final double sheetTop = 200.h;
    final double avatarSize = 100.w;
    final double avatarRadius = avatarSize / 2;
    // Avatar center Y = sheetTop
    final double avatarTop = sheetTop - avatarRadius;

    return Scaffold(
      backgroundColor: ColorsManager.softGrey,
      body: BlocConsumer<UserCubit, UserState>(
        listener: (context, state) {
          if (state is UserLoaded && state.isUpdating == false) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                elevation: 0,
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.transparent,
                content: AwesomeSnackbarContent(
                  title: 'Success!',
                  message: 'Profile updated successfully',
                  contentType: ContentType.success,
                ),
              ),
            );
          }
          if (state is UserError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                elevation: 0,
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.transparent,
                content: AwesomeSnackbarContent(
                  title: 'Error!',
                  message: state.message,
                  contentType: ContentType.failure,
                ),
              ),
            );
          }
        },
        builder: (context, userState) {
          if (userState is UserInitial) {
            return const ProfileShimmer();
          }

          final user = (userState as UserLoaded).user;

          // Sync controllers (simple logic)
          if (_nameController.text.isEmpty)
            _nameController.text = user.name ?? '';
          if (_emailController.text.isEmpty)
            _emailController.text = user.email ?? '';

          return Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              // --- 1. Red Header Layer ---
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: headerHeight,
                child: Container(
                  color: headerColor,
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.only(top: 50.h),
                  child: Text(
                    'Profile',
                    style: TextStyles.heading2.copyWith(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              // --- 2. White Sheet Layer ---
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
                  child: SingleChildScrollView(
                    // Add padding to push content down past the avatar
                    padding: EdgeInsets.fromLTRB(
                        24.w, avatarRadius + 20.h, 24.w, 40.h),
                    child: Column(
                      children: [
                        // Name is now inside the white sheet, below avatar
                        Text(
                          user.name ?? 'Guest',
                          textAlign: TextAlign.center,
                          style: TextStyles.heading2.copyWith(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          user.email ?? '',
                          textAlign: TextAlign.center,
                          style: TextStyles.body.copyWith(
                            color: Colors.grey,
                            fontSize: 14.sp,
                          ),
                        ),

                        SizedBox(height: 32.h),

                        // Menu Items
                        _buildMenuTile(
                          icon: CupertinoIcons.pencil,
                          title: 'Edit Profile Name',
                          onTap: () => _showEditNameDialog(context),
                        ),
                        _buildMenuTile(
                          icon: CupertinoIcons.lock,
                          title: 'Change Password',
                          onTap: () {},
                        ),

                        SizedBox(height: 20.h),
                        Divider(color: Colors.grey.shade200),
                        SizedBox(height: 10.h),

                        InkWell(
                          onTap: () {
                            context.read<AuthCubit>().logout();
                            context.go('/login');
                          },
                          borderRadius: BorderRadius.circular(12.r),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 16.h, horizontal: 16.w),
                            decoration: BoxDecoration(
                              color: ColorsManager.redAccent.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Row(
                              children: [
                                Icon(CupertinoIcons.square_arrow_left,
                                    color: ColorsManager.redAccent),
                                SizedBox(width: 16.w),
                                Text(
                                  'Logout',
                                  style: GoogleFonts.roboto(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: ColorsManager.redAccent,
                                  ),
                                ),
                                Spacer(),
                                Icon(CupertinoIcons.chevron_forward,
                                    color: ColorsManager.redAccent,
                                    size: 16.sp),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // --- 3. Floating Avatar Layer ---
              Positioned(
                top: avatarTop,
                child: GestureDetector(
                  onTap: _pickImage,
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
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: avatarSize / 2,
                          backgroundColor:
                              ColorsManager.primary.withOpacity(0.1),
                          backgroundImage: _getAvatarImage(user.avatarPath),
                          child: _getAvatarImage(user.avatarPath) == null
                              ? Icon(Icons.person,
                                  size: 40.sp, color: ColorsManager.primary)
                              : null,
                        ),
                        // Camera icon overlay
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.all(6.w),
                            decoration: BoxDecoration(
                              color: ColorsManager.primary,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: Icon(
                              CupertinoIcons.camera_fill,
                              size: 14.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showEditNameDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        title: Text(
          'Edit Name',
          style: GoogleFonts.roboto(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: ColorsManager.blackcolor,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Enter new name',
                hintStyle: GoogleFonts.roboto(color: ColorsManager.greycolor),
                filled: true,
                fillColor: ColorsManager.textfieldcolor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              ),
              style: GoogleFonts.roboto(color: ColorsManager.blackcolor),
            ),
          ],
        ),
        actionsPadding: EdgeInsets.only(bottom: 16.h, right: 16.w),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.roboto(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: ColorsManager.greycolor,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Trigger save
              _saveProfile();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorsManager.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
            ),
            child: Text(
              'Save',
              style: GoogleFonts.roboto(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFFF5F5F5), // Very light grey bg for icons
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.black54, size: 20.sp),
          ),
          title: Text(
            title,
            style: TextStyles.body.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 15.sp,
                color: Colors.black87),
          ),
          subtitle: subtitle != null
              ? Text(subtitle,
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey))
              : null,
          trailing: Icon(CupertinoIcons.chevron_forward,
              size: 16.sp, color: Colors.grey.shade400),
          onTap: onTap,
        ),
        Divider(height: 1, color: Colors.grey.shade100),
      ],
    );
  }
}
