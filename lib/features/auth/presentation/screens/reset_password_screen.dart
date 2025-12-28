import 'package:ala_feen/core/theme/app_colors.dart';
import 'package:ala_feen/core/theme/app_text_styles.dart';
import 'package:ala_feen/core/utils/validator.dart';
import 'package:ala_feen/features/auth/presentation/cubits/reset_password_cubit/reset_password_cubit.dart';
import 'package:ala_feen/features/auth/presentation/cubits/reset_password_cubit/reset_password_state.dart';
import 'package:ala_feen/features/auth/presentation/screens/login_screen.dart';
import 'package:ala_feen/features/auth/presentation/widgets/custom_text_form_field.dart';
import 'package:ala_feen/features/auth/presentation/widgets/logo_with_back_button.dart';
import 'package:ala_feen/features/get_started/widgets/custom_button_widget.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});
  static const String routeName = '/reset-password';

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
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
    return BlocListener<ResetPasswordCubit, ResetPasswordState>(
      listener: (context, state) {
        if (state is ResetPasswordSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم تغيير كلمة المرور بنجاح!'),
              backgroundColor: Colors.green,
            ),
          );
          GoRouter.of(context).go(LoginScreen.routeName);
        } else if (state is ResetPasswordFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.h),
              child: Form(
                key: _formKey,
                autovalidateMode: _autoValidateMode,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),
                    const LogoWithBackButton(),
                    SizedBox(height: 40.h),
                    FadeInRight(
                      child: Text(
                        'إعادة تعيين كلمة المرور',
                        style: AppTextStyles.bold25(context),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    FadeInRight(
                      delay: const Duration(milliseconds: 200),
                      child: Text(
                        'أدخل كلمة المرور الجديدة الخاصة بك أدناه.',
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
                            'كلمة المرور الجديدة',
                            style: AppTextStyles.bold14(context),
                          ),
                          CustomTextFormField(
                            hintText: 'أدخل كلمة المرور الجديدة',
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
                            'تأكيد كلمة المرور',
                            style: AppTextStyles.bold14(context),
                          ),
                          CustomTextFormField(
                            hintText: 'تأكيد كلمة المرور الجديدة',
                            controller: _confirmPasswordController,
                            obscureText: _isConfirmPasswordVisible,
                            validator: (value) {
                              if (value != _passwordController.text) {
                                return 'كلمات المرور غير متطابقة';
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
                      child:
                          BlocBuilder<ResetPasswordCubit, ResetPasswordState>(
                            builder: (context, state) {
                              if (state is ResetPasswordLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.primary,
                                  ),
                                );
                              }
                              return CustomButtonWidget(
                                backgroundColor: AppColors.primary,
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    context
                                        .read<ResetPasswordCubit>()
                                        .resetPassword(
                                          newPassword: _passwordController.text
                                              .trim(),
                                        );
                                  } else {
                                    setState(() {
                                      _autoValidateMode =
                                          AutovalidateMode.always;
                                    });
                                  }
                                },
                                child: Text(
                                  'تغيير كلمة المرور',
                                  style: AppTextStyles.bold16(context),
                                ),
                              );
                            },
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
