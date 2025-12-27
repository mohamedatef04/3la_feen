import 'package:ala_feen/features/auth/presentation/screens/register_screen.dart';
import 'package:ala_feen/core/theme/app_colors.dart';
import 'package:ala_feen/core/theme/app_text_styles.dart';
import 'package:ala_feen/core/utils/app_strings.dart';
import 'package:ala_feen/core/utils/validator.dart';
import 'package:ala_feen/features/auth/presentation/widgets/custom_text_form_field.dart';
import 'package:ala_feen/features/get_started/widgets/custom_button_widget.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class LoginDriverTextFieldsColumnWidget extends StatelessWidget {
  const LoginDriverTextFieldsColumnWidget({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.formKey,
    required this.autoValidateMode,
    this.onSubmit,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey;
  final AutovalidateMode autoValidateMode;
  final VoidCallback? onSubmit;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 15.h,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Email Field
        _buildFieldWithHeader(
          context: context,
          headerText: AppStrings.phoneNumber,
          hintText: 'أدخل ${AppStrings.phoneNumber}',
          icon: Icons.email_outlined,
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          validator: Validator.validateEmail,
        ),
        _buildFieldWithHeader(
          context: context,
          headerText: AppStrings.password,
          hintText: 'أدخل ${AppStrings.password}',
          icon: Icons.lock_outline,
          controller: passwordController,
          obscureText: true,
          validator: Validator.validatePassword,
        ),

        FadeInUp(
          child: CustomButtonWidget(
            backgroundColor: AppColors.primary,
            onPressed: () {
              if (formKey.currentState!.validate()) {
                // Form is valid, call onSubmit callback
                onSubmit?.call();
              }
            },
            child: Text(
              AppStrings.login,
              style: AppTextStyles.bold16(context),
            ),
          ),
        ),
        FadeInUp(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'ليس لديك حساب ؟ ',
                style: AppTextStyles.medium14(context),
              ),
              GestureDetector(
                onTap: () => context.push(RegisterScreen.routeName),
                child: Text(
                  AppStrings.newUser,
                  style: AppTextStyles.bold14(context).copyWith(
                    color: AppColors.primary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
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
    TextEditingController? controller,
    TextInputType? keyboardType,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8.h,
      children: [
        FadeInRight(
          child: Text(headerText, style: AppTextStyles.bold14(context)),
        ),
        FadeInRight(
          child: CustomTextFormField(
            hintText: hintText,
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            validator: validator,
            prefixIcon: Icon(
              icon,
              color: AppColors.white,
            ),
          ),
        ),
      ],
    );
  }
}
