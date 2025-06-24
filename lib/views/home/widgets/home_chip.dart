import 'package:code_review_and_analysis/utils/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

Widget chipWidget(String text) => Container(
  height: 10.h,
  padding: const EdgeInsets.all(12),
  margin: EdgeInsets.only(bottom: 1.h),
  decoration: BoxDecoration(
    color: AppColor.secondaryBackgroundColor,
    borderRadius: BorderRadius.circular(8),
  ),
  child: Text(
    text,
    style: TextStyle(
      color: AppColor.textColor,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
    overflow: TextOverflow.ellipsis,
    maxLines: 3,
  ),
);
