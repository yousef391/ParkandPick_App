import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:testtt/core/constants/text_manager.dart';
import 'package:testtt/core/routes/app_pages.dart';
import 'package:testtt/core/theme/colors_manager.dart';
import 'package:testtt/core/theme/text_styles.dart';
import 'package:testtt/presentation/screens/login_screen.dart';
import 'package:testtt/presentation/widgets/button_widget.dart';
import 'package:testtt/presentation/widgets/text_field_wdget.dart';
import 'package:testtt/providers/auth_provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isObscureText = true;

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _onSignupPressed() async {
    if (_formKey.currentState!.validate()) {
      final auth = context.read<AuthProvider>();
      final success = await auth.signup(
        name: fullNameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      if (!mounted) return;
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Account created successfully")),
        );
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Signup failed"),
            backgroundColor: ColorsManager.redAccent,
          ),
        );
      }
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
                // Sign Up Title
                Text(
                  'Sign Up',
                  style: TextStyles.heading1.copyWith(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8.h),
                // Welcome Message
                Text(
                  'Create an account to get started',
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
                        hintText: "Full Name",
                        controller: fullNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Full name is required";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 12.h),
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
                      SizedBox(height: 50.h),
                      ButtonWidget(
                        height: 56.h,
                        title: "Sign Up",
                        onTap: _onSignupPressed,
                      ),
                      SizedBox(height: 30.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an account?"),
                          TextButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            ),
                            child: const Text("Login"),
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
