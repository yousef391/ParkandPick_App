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

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().login(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Error',
            message: TextManager.failedLogin,
            contentType: ContentType.failure,
          ),
        ),
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
              title: 'Welcome Back!',
              message: TextManager.successLogin,
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
              title: 'Oh Snap!',
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
                              height: 100.h,
                              width: 100.h, // Square container
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
                              // Placeholder if logo not found, or use asset
                              child: ClipOval(
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Image.asset(
                                    "assets/images/logo.png",
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(
                                        Icons.local_cafe,
                                        size: 40.sp,
                                        color: ColorsManager.primary,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 24.h),
                            Text(
                              'Park&Pick',
                              style: TextStyles.heading1.copyWith(
                                fontSize: 32.sp,
                                fontWeight: FontWeight.w800,
                                color: ColorsManager.primary,
                                letterSpacing: -0.5,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              TextManager.welcomeBack,
                              style: TextStyles.body.copyWith(
                                color: ColorsManager.greycolor,
                                fontSize: 16.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 50.h),

                      // Login Form
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Email Address",
                              style: TextStyles.bodyBold.copyWith(
                                color: ColorsManager.blackcolor,
                                fontSize: 14.sp,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            TextFieldWidget(
                              hintText: "Enter your email",
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
                              hintText: "Enter your password",
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
                                iconSize: 22,
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
                            SizedBox(height: 12.h),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  // TODO: Add forgot password logic
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: const Size(0, 0),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  TextManager.forgetPassword,
                                  style: TextStyles.infoText.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 32.h),
                            BlocBuilder<AuthCubit, AuthState>(
                              builder: (context, state) {
                                return ButtonWidget(
                                  height: 56.h,
                                  title: state is AuthLoading
                                      ? 'Logging in...'
                                      : TextManager.loginButton,
                                  onTap: state is AuthLoading
                                      ? () {}
                                      : _onLoginPressed,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40.h),

                      // Sign Up Link with Divider style
                      Row(
                        children: [
                          Expanded(
                              child: Divider(color: ColorsManager.softGrey)),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Text(
                              "Or continue with",
                              style: TextStyles.smallText,
                            ),
                          ),
                          Expanded(
                              child: Divider(color: ColorsManager.softGrey)),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have an account?",
                              style: TextStyles.body),
                          TextButton(
                            onPressed: () {
                              context.push('/signup');
                            },
                            child: Text("Sign Up",
                                style: TextStyles.bodyBold
                                    .copyWith(color: ColorsManager.primary)),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
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
