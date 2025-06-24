import 'package:code_review_and_analysis/controllers/home/auth_controller.dart';
import 'package:code_review_and_analysis/routes/app_route_path.dart';
import 'package:code_review_and_analysis/routes/app_routes.dart';
import 'package:code_review_and_analysis/utils/theme/app_color.dart';
import 'package:code_review_and_analysis/views/auth/widgets/auth_custom_button.dart';
import 'package:code_review_and_analysis/views/auth/widgets/auth_text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
  final formKey = GlobalKey<FormState>();
  final _authController = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColor.secondaryBackgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Login Now',
                style: TextStyle(
                  color: AppColor.mainheadingtextColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4.h),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    AuthTextField(
                      controller: emailController,
                      hintText: 'Enter Your Email',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is Required.';
                        } else if (!emailRegex.hasMatch(value)) {
                          return "Enter a Valid Email.";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 2.h),
                    AuthTextField(
                      controller: passwordController,
                      hintText: 'Enter Your Password',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required.';
                        } else if (value.length < 8) {
                          return "Password Should be 8 Character long.";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 3.h),
              Obx(
                () => AuthCustomButton(
                  isloading: _authController.isloading.value,
                  onClick: () async {
                    if (formKey.currentState!.validate()) {
                      await _authController.loginUser(
                        email: emailController.text.trim(),
                        password: passwordController.text.trim(),
                      );
                      emailController.clear();
                      passwordController.clear();
                    }
                  },
                  text: 'Sign In',
                ),
              ),

              SizedBox(height: 2.h),
              Text(
                'OR',
                style: TextStyle(
                  color: AppColor.whiteColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2.h),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Don\'t have an Account?  ',
                      style: TextStyle(
                        color: AppColor.secondarytextColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                      text: 'Register Now',
                      style: TextStyle(
                        color: AppColor.mainheadingtextColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer:
                          TapGestureRecognizer()
                            ..onTap = () {
                              appNavigatorKey.currentContext?.pushReplacement(
                                AppRoutePath.registerPageRoute,
                              );
                            },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
