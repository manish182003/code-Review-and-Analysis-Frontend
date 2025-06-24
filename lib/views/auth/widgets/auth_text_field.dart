import 'package:code_review_and_analysis/utils/theme/app_color.dart';
import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final FormFieldValidator validator;
  final Function(String)? onChanged;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      onChanged: onChanged,
      style: TextStyle(color: AppColor.errorFillColor),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColor.selectedContainerColor,
        hintText: hintText,
        hintStyle: TextStyle(color: AppColor.errorFillColor),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColor.blackColor, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColor.blackColor, width: 0.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColor.errorBorderColor, width: 0.5),
        ),
        errorStyle: TextStyle(
          color: AppColor.tertiarytextColor,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColor.errorBorderColor, width: 0.5),
        ),
      ),
    );
  }
}
