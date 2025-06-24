import 'package:code_review_and_analysis/controllers/home/auth_controller.dart';
import 'package:code_review_and_analysis/routes/app_route_path.dart';
import 'package:code_review_and_analysis/routes/app_routes.dart';
import 'package:code_review_and_analysis/utils/storage/device_utils.dart';
import 'package:code_review_and_analysis/utils/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/web.dart';

import 'package:sizer/sizer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _authController = Get.find<AuthController>();
  @override
  void initState() {
    goToNextScreen();
    super.initState();
  }

  goToNextScreen() async {
    await Future.delayed(Duration(seconds: 3));

    final token = await DeviceUtils.getAppToken();

    Logger().i("Token-> $token");

    if (token != null) {
      await _authController.getCurrentUser();
    } else {
      appNavigatorKey.currentContext?.go(AppRoutePath.homeRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Icon
            Container(
              height: 12.h,
              width: 12.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.secondaryBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              padding: EdgeInsets.all(16),
              child: Image.asset('assets/icons/splash.png'),
            ),
            SizedBox(height: 3.h),

            // App Name
            Text(
              'Codec App',
              style: TextStyle(
                color: AppColor.mainheadingtextColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            SizedBox(height: 1.h),

            // Tagline
            Text(
              'AI-Powered Code Review',
              style: TextStyle(
                color: AppColor.secondarytextColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 4.h),

            // Loading indicator
            CircularProgressIndicator(
              color: AppColor.mainheadingtextColor,
              strokeWidth: 2.5,
            ),
          ],
        ),
      ),
    );
  }
}
