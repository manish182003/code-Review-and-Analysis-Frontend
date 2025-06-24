import 'package:code_review_and_analysis/routes/app_routes.dart';
import 'package:code_review_and_analysis/utils/binding/app_dependency.dart';
import 'package:code_review_and_analysis/utils/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

void main() async {
  await dotenv.load();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, screenType) {
        return GetMaterialApp.router(
          theme: ThemeData(
            scaffoldBackgroundColor: AppColor.appBackgroundColor,
            textTheme: GoogleFonts.interTextTheme(),
          ),
          initialBinding: AppDependency(),
          routerDelegate: appRouter.routerDelegate,
          routeInformationParser: appRouter.routeInformationParser,
          routeInformationProvider: appRouter.routeInformationProvider,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
