import 'package:code_review_and_analysis/routes/app_route_path.dart';
import 'package:code_review_and_analysis/views/auth/screens/login_screen.dart';
import 'package:code_review_and_analysis/views/auth/screens/register_screen.dart';
import 'package:code_review_and_analysis/views/home/screens/home_screen.dart';
import 'package:code_review_and_analysis/views/splash/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: appNavigatorKey,
  initialLocation: AppRoutePath.initialRoute,
  routes: [
    GoRoute(
      path: AppRoutePath.initialRoute,
      pageBuilder: (context, state) {
        return CupertinoPage(key: state.pageKey, child: SplashScreen());
      },
    ),

    GoRoute(
      path: AppRoutePath.loginPageRoute,

      pageBuilder: (context, state) {
        return CupertinoPage(key: state.pageKey, child: LoginScreen());
      },
    ),
    GoRoute(
      path: AppRoutePath.registerPageRoute,
      pageBuilder: (context, state) {
        return CupertinoPage(key: state.pageKey, child: RegisterScreen());
      },
    ),
    GoRoute(
      path: AppRoutePath.homeRoute,
      pageBuilder: (context, state) {
        return CupertinoPage(key: state.pageKey, child: HomeScreen());
      },
    ),
  ],
);
