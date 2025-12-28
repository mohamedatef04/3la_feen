import 'package:ala_feen/core/functions/show_snack_bar.dart';
import 'package:ala_feen/core/theme/app_colors.dart';
import 'package:ala_feen/core/theme/app_text_styles.dart';
import 'package:ala_feen/core/utils/app_strings.dart';
import 'package:ala_feen/core/utils/validator.dart';
import 'package:ala_feen/features/auth/presentation/cubits/reset_password_cubit/reset_password_cubit.dart';
import 'package:ala_feen/features/auth/presentation/cubits/reset_password_cubit/reset_password_state.dart';
import 'package:ala_feen/features/auth/presentation/widgets/shared_widgets/custom_text_form_field.dart';
import 'package:ala_feen/features/get_started/widgets/custom_button_widget.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ResetPasswordForm extends StatefulWidget {
  const ResetPasswordForm({super.key});

  @override
  State<ResetPasswordForm> createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<ResetPasswordForm> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;

  bool _isPasswordVisible = true;
  bool _isConfirmPasswordVisible = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: _autoValidateMode,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FadeInRight(
            child: Text(
              AppStrings.resetPassword,
              style: AppTextStyles.bold25(context),
            ),
          ),
          SizedBox(height: 10.h),
          FadeInRight(
            delay: const Duration(milliseconds: 200),
            child: Text(
              AppStrings.resetPasswordDescription,
              style: AppTextStyles.medium16(context).copyWith(
                color: Colors.grey,
              ),
            ),
          ),
          SizedBox(height: 40.h),

          // New Password
          FadeInRight(
            delay: const Duration(milliseconds: 400),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8.h,
              children: [
                Text(
                  AppStrings.newPassword,
                  style: AppTextStyles.bold14(context),
                ),
                CustomTextFormField(
                  hintText: AppStrings.enterNewPassword,
                  controller: _passwordController,
                  obscureText: _isPasswordVisible,
                  validator: Validator.validatePassword,
                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    color: AppColors.white,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () => setState(
                      () => _isPasswordVisible = !_isPasswordVisible,
                    ),
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),

          // Confirm Password
          FadeInRight(
            delay: const Duration(milliseconds: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8.h,
              children: [
                Text(
                  AppStrings.confirmPassword,
                  style: AppTextStyles.bold14(context),
                ),
                CustomTextFormField(
                  hintText: AppStrings.confirmNewPassword,
                  controller: _confirmPasswordController,
                  obscureText: _isConfirmPasswordVisible,
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return AppStrings.passwordsDoNotMatch;
                    }
                    return null;
                  },
                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    color: AppColors.white,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () => setState(
                      () => _isConfirmPasswordVisible =
                          !_isConfirmPasswordVisible,
                    ),
                    icon: Icon(
                      _isConfirmPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 40.h),
          FadeInRight(
            delay: const Duration(milliseconds: 800),
            child: BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
              listener: (context, state) {
                if (state is ResetPasswordSuccess) {
                  showCustomSnackBar(
                    context,
                    AppStrings.passwordChangedSuccessfully,
                  );
                  GoRouter.of(context).go('/');
                } else if (state is ResetPasswordFailure) {
                  showCustomSnackBar(
                    context,
                    state.errorMessage,
                    isError: true,
                  );
                }
              },
              builder: (context, state) {
                return CustomButtonWidget(
                  backgroundColor: AppColors.primary,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      context.read<ResetPasswordCubit>().resetPassword(
                        newPassword: _passwordController.text.trim(),
                      );
                    } else {
                      setState(() {
                        _autoValidateMode = AutovalidateMode.always;
                      });
                    }
                  },
                  child: state is ResetPasswordLoading
                      ? const CupertinoActivityIndicator(
                          color: AppColors.white,
                        )
                      : Text(
                          AppStrings.changePassword,
                          style: AppTextStyles.bold16(context),
                        ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
