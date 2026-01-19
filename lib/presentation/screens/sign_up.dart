import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:testtt/core/constants/text_manager.dart';
import 'package:testtt/core/theme/colors_manager.dart';
import 'package:testtt/core/theme/text_styles.dart';
import 'package:testtt/presentation/cubits/auth/auth_cubit.dart';

import 'package:testtt/presentation/widgets/button_widget.dart';
import 'package:testtt/presentation/widgets/text_field_wdget.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isObscureText = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _onSignupPressed() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().signup(
            name: fullNameController.text.trim(),
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          final snackBar = SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'Success!',
              message: "Account created successfully",
              contentType: ContentType.success,
            ),
          );
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);
          context.go('/home');
        } else if (state is AuthError) {
          final snackBar = SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'Error!',
              message: state.message,
              contentType: ContentType.failure,
            ),
          );
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);
        }
      },
      child: Scaffold(
        backgroundColor: ColorsManager.whitecolor,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 40.h),
                      // Header Section with Logo
                      Center(
                        child: Column(
                          children: [
                            Container(
                              height: 80.h,
                              width: 80.h, // Slightly smaller than login
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: ColorsManager.softGrey,
                                boxShadow: [
                                  BoxShadow(
                                    color: ColorsManager.blackcolor
                                        .withOpacity(0.1),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Image.asset(
                                    "assets/images/logo.png",
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(
                                        Icons.person_add,
                                        size: 32.sp,
                                        color: ColorsManager.primary,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 24.h),
                            Text(
                              'Sign Up',
                              style: TextStyles.heading1.copyWith(
                                fontSize: 32.sp,
                                fontWeight: FontWeight.w800,
                                color: ColorsManager.primary,
                                letterSpacing: -0.5,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'Create a new account',
                              style: TextStyles.body.copyWith(
                                color: ColorsManager.greycolor,
                                fontSize: 16.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40.h),

                      // Sign Up Form
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Full Name",
                              style: TextStyles.bodyBold.copyWith(
                                color: ColorsManager.blackcolor,
                                fontSize: 14.sp,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            TextFieldWidget(
                              hintText: "Enter your full name",
                              controller: fullNameController,
                              prefixIcon:
                                  const Icon(CupertinoIcons.person, size: 20),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Full name is required";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20.h),
                            Text(
                              "Email Address",
                              style: TextStyles.bodyBold.copyWith(
                                color: ColorsManager.blackcolor,
                                fontSize: 14.sp,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            TextFieldWidget(
                              hintText: TextManager.emailHint,
                              controller: emailController,
                              prefixIcon:
                                  const Icon(CupertinoIcons.mail, size: 20),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return TextManager.errorEmptyEmail;
                                }
                                final emailRegex = RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                );
                                if (!emailRegex.hasMatch(value)) {
                                  return TextManager.errorInvalidEmail;
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20.h),
                            Text(
                              "Password",
                              style: TextStyles.bodyBold.copyWith(
                                color: ColorsManager.blackcolor,
                                fontSize: 14.sp,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            TextFieldWidget(
                              hintText: TextManager.passwordHint,
                              controller: passwordController,
                              prefixIcon:
                                  const Icon(CupertinoIcons.lock, size: 20),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return TextManager.errorEmptyPassword;
                                }
                                if (value.length < 8) {
                                  return TextManager.errorShortPassword;
                                }
                                return null;
                              },
                              obscureText: isObscureText,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isObscureText = !isObscureText;
                                  });
                                },
                                icon: isObscureText
                                    ? const Icon(CupertinoIcons.eye_slash)
                                    : const Icon(CupertinoIcons.eye),
                                color: ColorsManager.greycolor,
                              ),
                            ),
                            SizedBox(height: 40.h),
                            BlocBuilder<AuthCubit, AuthState>(
                              builder: (context, state) {
                                return ButtonWidget(
                                  height: 56.h,
                                  title: state is AuthLoading
                                      ? 'Creating Account...'
                                      : "Sign Up",
                                  onTap: state is AuthLoading
                                      ? () {}
                                      : _onSignupPressed,
                                );
                              },
                            ),
                            SizedBox(height: 30.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Already have an account?",
                                  style: TextStyles.body,
                                ),
                                TextButton(
                                  onPressed: () => context.go('/login'),
                                  child: Text(
                                    "Login",
                                    style: TextStyles.bodyBold.copyWith(
                                      color: ColorsManager.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.h),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
