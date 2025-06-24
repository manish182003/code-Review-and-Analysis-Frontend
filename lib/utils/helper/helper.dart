import 'package:code_review_and_analysis/routes/app_routes.dart';
import 'package:code_review_and_analysis/utils/theme/app_color.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

class Helper {
  static void toast(String message) {
    Fluttertoast.showToast(
      msg: message,
      gravity: ToastGravity.BOTTOM,
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: AppColor.secondaryBackgroundColor,
      textColor: AppColor.tertiarytextColor,
      fontSize: 16,
    );
  }

  static void showErrorToast(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    final entry = OverlayEntry(
      builder:
          (_) => Positioned(
            top: 60,
            left: 20,
            right: 20,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  message,
                  style: TextStyle(color: Colors.white, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
    );

    overlay.insert(entry);
    Future.delayed(Duration(seconds: 2), () => entry.remove());
  }
}
