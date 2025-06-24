import 'dart:io';
import 'dart:math';

import 'package:code_review_and_analysis/utils/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

Widget buildCompactFileView(File file, [double? iconSize, double? fontsize]) {
  final fileName = p.basename(file.path);

  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Icon(Icons.insert_drive_file, color: Colors.blue, size: iconSize ?? 30),
      SizedBox(height: 4),
      Text(
        fileName,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: AppColor.textColor,
          fontSize: fontsize ?? 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    ],
  );
}

String formatBytes(int bytes, int decimals) {
  if (bytes == 0) return "0 B";
  const k = 1024;
  const sizes = ['B', 'KB', 'MB', 'GB'];
  final i = (bytes / k) ~/ 1;
  return "${(bytes / pow(k, i)).toStringAsFixed(decimals)} ${sizes[i]}";
}
