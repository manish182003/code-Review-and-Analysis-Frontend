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

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final _authController = Get.find<AuthController>();
  final formKey = GlobalKey<FormState>();
  final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");

  RxBool hasUppercase = false.obs;
  RxBool hasLowercase = false.obs;
  RxBool hasDigit = false.obs;
  RxBool hasSpecialChar = false.obs;
  RxBool hasMinLength = false.obs;

  void validatePassword(String value) {
    hasUppercase.value = value.contains(RegExp(r'[A-Z]'));
    hasLowercase.value = value.contains(RegExp(r'[a-z]'));
    hasDigit.value = value.contains(RegExp(r'\d'));
    hasSpecialChar.value = value.contains(RegExp(r'[@$!%*?&]'));
    hasMinLength.value = value.length >= 8;
  }

  Widget buildValidationRow(bool condition, String text) {
    return Row(
      children: [
        Icon(
          condition ? Icons.check_circle : Icons.cancel,
          color: condition ? Colors.green : Colors.red,
          size: 18,
        ),
        SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: condition ? Colors.green : Colors.red,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  bool allValid() {
    return hasUppercase.value &&
        hasLowercase.value &&
        hasDigit.value &&
        hasSpecialChar.value &&
        hasMinLength.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
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
                  'Register Now',
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
                        onChanged: validatePassword,
                        validator: (value) {
                          return allValid()
                              ? null
                              : 'Please meet all password requirements';
                        },
                      ),
                      SizedBox(height: 1.h),
                      Obx(() {
                        return Column(
                          children: [
                            buildValidationRow(
                              hasMinLength.value,
                              "Minimum 8 characters",
                            ),
                            buildValidationRow(
                              hasUppercase.value,
                              "At least 1 uppercase letter",
                            ),
                            buildValidationRow(
                              hasLowercase.value,
                              "At least 1 lowercase letter",
                            ),
                            buildValidationRow(
                              hasDigit.value,
                              "At least 1 number",
                            ),
                            buildValidationRow(
                              hasSpecialChar.value,
                              "At least 1 special character (@\$!%*?&)",
                            ),
                          ],
                        );
                      }),
                      SizedBox(height: 1.h),
                      AuthTextField(
                        controller: confirmPasswordController,
                        hintText: 'Enter Your Confirm Password',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Confirm Password is Required.';
                          } else if (value != passwordController.text) {
                            return 'Passwords do not match.';
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
                        await _authController.registerUser(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                        );
                        emailController.clear();
                        passwordController.clear();
                        confirmPasswordController.clear();

                        hasUppercase.value = false;
                        hasLowercase.value = false;
                        hasDigit.value = false;
                        hasSpecialChar.value = false;
                        hasMinLength.value = false;
                      }
                    },
                    text: 'Sign Up',
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
                        text: 'Already have an Account?  ',
                        style: TextStyle(
                          color: AppColor.secondarytextColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextSpan(
                        text: 'Login Now',
                        style: TextStyle(
                          color: AppColor.mainheadingtextColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer:
                            TapGestureRecognizer()
                              ..onTap = () {
                                appNavigatorKey.currentContext?.pushReplacement(
                                  AppRoutePath.loginPageRoute,
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
      ),
    );
  }
}
