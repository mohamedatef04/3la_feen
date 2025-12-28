import 'package:ala_feen/core/functions/show_snack_bar.dart';
import 'package:ala_feen/core/theme/app_colors.dart';
import 'package:ala_feen/core/theme/app_text_styles.dart';
import 'package:ala_feen/core/utils/app_strings.dart';
import 'package:ala_feen/core/utils/validator.dart';
import 'package:ala_feen/features/auth/presentation/cubits/forget_password_cubit/forget_password_cubit.dart';
import 'package:ala_feen/features/auth/presentation/cubits/forget_password_cubit/forget_password_state.dart';
import 'package:ala_feen/features/auth/presentation/widgets/shared_widgets/custom_text_form_field.dart';
import 'package:ala_feen/features/get_started/widgets/custom_button_widget.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForgetPasswordForm extends StatefulWidget {
  const ForgetPasswordForm({super.key});

  @override
  State<ForgetPasswordForm> createState() => _ForgetPasswordFormState();
}

class _ForgetPasswordFormState extends State<ForgetPasswordForm> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;

  @override
  void dispose() {
    _emailController.dispose();
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
              AppStrings.forgetPassword,
              style: AppTextStyles.bold25(context),
            ),
          ),
          SizedBox(height: 10.h),
          FadeInRight(
            delay: const Duration(milliseconds: 200),
            child: Text(
              AppStrings.forgetPasswordDescription,
              style: AppTextStyles.medium16(context).copyWith(
                color: Colors.grey,
              ),
            ),
          ),
          SizedBox(height: 40.h),
          FadeInRight(
            delay: const Duration(milliseconds: 400),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8.h,
              children: [
                Text(
                  AppStrings.email,
                  style: AppTextStyles.bold14(context),
                ),
                CustomTextFormField(
                  hintText: AppStrings.enterEmail,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validator.validateEmail,
                  prefixIcon: const Icon(
                    Icons.email_outlined,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 40.h),
          FadeInRight(
            delay: const Duration(milliseconds: 600),
            child: BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
              listener: (context, state) {
                if (state is ForgetPasswordSuccess) {
                  showCustomSnackBar(
                    context,
                    AppStrings.resetLinkSent,
                  );
                } else if (state is ForgetPasswordFailure) {
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
                      context
                          .read<ForgetPasswordCubit>()
                          .logInForForgotPassword(
                            email: _emailController.text.trim(),
                          );
                    } else {
                      setState(() {
                        _autoValidateMode = AutovalidateMode.always;
                      });
                    }
                  },
                  child: state is ForgetPasswordLoading
                      ? const CupertinoActivityIndicator(
                          color: AppColors.white,
                        )
                      : Text(
                          AppStrings.send,
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
