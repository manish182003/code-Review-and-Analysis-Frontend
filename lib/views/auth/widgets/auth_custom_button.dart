import 'package:code_review_and_analysis/utils/theme/app_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class AuthCustomButton extends StatelessWidget {
  final VoidCallback onClick;
  final String text;
  bool isloading;
  AuthCustomButton({
    super.key,
    required this.onClick,
    required this.text,
    this.isloading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isloading ? null : onClick,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.responsecontainerColor,
        minimumSize: Size(100.w, 6.h),
        side: BorderSide(color: AppColor.mainheadingtextColor, width: 0.6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child:
          isloading
              ? SizedBox(
                height: 23,
                width: 23,
                child: CircularProgressIndicator(color: AppColor.greyColor),
              )
              : Text(
                text,
                style: TextStyle(
                  color: AppColor.secondarytextColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
    );
  }
}
