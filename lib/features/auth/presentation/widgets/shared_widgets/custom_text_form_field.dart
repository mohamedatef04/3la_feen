import 'package:ala_feen/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.hintText,
    this.suffixIcon,
    this.prefixIcon,
    this.obscureText = false,
    this.validator,
    this.controller,
    this.keyboardType,
    this.onChanged,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 20,
    ),
    this.maxLines = 1,
    this.fillColor,
    this.enabled = true,
    this.autofocus = false,
    this.focusNode,
  });
  final TextEditingController? controller;
  final String hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;
  final EdgeInsetsGeometry? contentPadding;
  final int? maxLines;
  final Color? fillColor;
  final bool enabled;
  final bool autofocus;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      enabled: enabled,
      autofocus: autofocus,
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        fontSize: 16.sp,
      ),
      keyboardType: keyboardType,
      controller: controller,
      maxLines: maxLines,
      onChanged: onChanged,
      validator: validator,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: contentPadding,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        fillColor:
            fillColor ?? Theme.of(context).colorScheme.surfaceContainerLow,
        filled: true,
        hintStyle: AppTextStyles.medium14(context).copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
            width: 1.w,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
            width: 1.w,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 1.5.w,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
            width: 1.w,
          ),
        ),
      ),
    );
  }
}
