import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:testtt/core/constants/text_manager.dart';
import 'package:testtt/core/routes/app_pages.dart';
import 'package:testtt/core/theme/colors_manager.dart';
import 'package:testtt/core/theme/text_styles.dart';
import 'package:testtt/presentation/screens/sign_up.dart';
import 'package:testtt/presentation/widgets/button_widget.dart';
import 'package:testtt/presentation/widgets/text_field_wdget.dart';
import 'package:testtt/providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isObscureText = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _onLoginPressed() async {
    if (_formKey.currentState!.validate()) {
      final auth = context.read<AuthProvider>();
      final success = await auth.login(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      if (!mounted) return;
      if (success) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text(TextManager.successLogin)));
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(TextManager.failedLogin),
            backgroundColor: ColorsManager.redAccent,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(TextManager.failedLogin),
          backgroundColor: ColorsManager.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 30.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 24.h),
                // App Title
                Text(
                  'Park&Pick',
                  style: TextStyles.heading1.copyWith(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w700,
                    color: ColorsManager.primary,
                  ),
                ),
                SizedBox(height: 24.h),
                // Login Title
                Text(
                  'Login',
                  style: TextStyles.heading1.copyWith(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8.h),
                // Welcome Message
                Text(
                  TextManager.welcomeBack,
                  style: TextStyles.body.copyWith(
                    color: ColorsManager.greycolor,
                    fontSize: 15.sp,
                  ),
                ),
                SizedBox(height: 40.h),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFieldWidget(
                        hintText: TextManager.emailHint,
                        controller: emailController,
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
                      SizedBox(height: 12.h),
                      TextFieldWidget(
                        hintText: TextManager.passwordHint,
                        controller: passwordController,
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
                              ? const Icon(Icons.visibility_off_outlined)
                              : const Icon(Icons.visibility_outlined),
                          color: ColorsManager.greycolor,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          TextManager.forgetPassword,
                          style: TextStyles.infoText,
                        ),
                      ),
                      SizedBox(height: 50.h),
                      ButtonWidget(
                        height: 56.h,
                        title: TextManager.loginButton,
                        onTap: _onLoginPressed,
                      ),
                      SizedBox(height: 30.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don’t have an account?"),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const SignupScreen(),
                                ),
                              );
                            },
                            child: const Text("Sign Up"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
