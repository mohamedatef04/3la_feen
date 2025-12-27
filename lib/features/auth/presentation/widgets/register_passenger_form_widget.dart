import 'package:ala_feen/core/theme/app_colors.dart';
import 'package:ala_feen/core/theme/app_text_styles.dart';
import 'package:ala_feen/core/utils/app_strings.dart';
import 'package:ala_feen/features/auth/presentation/screens/registration_success_screen.dart';
import 'package:ala_feen/features/auth/presentation/widgets/custom_text_form_field.dart';
import 'package:ala_feen/features/get_started/widgets/custom_button_widget.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class RegisterPassengerFormWidget extends StatelessWidget {
  const RegisterPassengerFormWidget({
    super.key,
    required this.nameController,
    required this.phoneController,
    required this.passwordController,
    this.onSubmit,
  });

  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final VoidCallback? onSubmit;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 15.h,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Name Field
        _buildFieldWithHeader(
          context: context,
          headerText: AppStrings.fullName,
          hintText: 'أدخل ${AppStrings.fullName}',
          icon: Icons.person_outline,
          controller: nameController,
        ),
        // Phone Field
        _buildFieldWithHeader(
          context: context,
          headerText: AppStrings.phoneNumber,
          hintText: 'أدخل ${AppStrings.phoneNumber}',
          icon: Icons.phone_android_outlined,
          controller: phoneController,
          keyboardType: TextInputType.phone,
        ),
        // Password Field
        _buildFieldWithHeader(
          context: context,
          headerText: AppStrings.password,
          hintText: 'أدخل ${AppStrings.password}',
          icon: Icons.lock_outline,
          controller: passwordController,
          obscureText: true,
        ),
        SizedBox(height: 15.h),
        // Submit Button
        FadeInUp(
          duration: const Duration(milliseconds: 600),
          child: SizedBox(
            width: double.infinity,
            height: 56.h,
            child: CustomButtonWidget(
              onPressed: () {
                if (onSubmit != null) {
                  onSubmit!();
                } else {
                  context.push(RegistrationSuccessScreen.routeName);
                }
              },
              backgroundColor: AppColors.primary,
              child: Text(
                AppStrings.send,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFieldWithHeader({
    required BuildContext context,
    required String headerText,
    required String hintText,
    required IconData icon,
    required TextEditingController controller,
    TextInputType? keyboardType,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return FadeInUp(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            headerText,
            style: AppTextStyles.bold14(context).copyWith(
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: 8.h),
          CustomTextFormField(
            controller: controller,
            hintText: hintText,
            prefixIcon: Icon(icon),
            keyboardType: keyboardType,
            obscureText: obscureText,
            validator: validator,
          ),
        ],
      ),
    );
  }
}
