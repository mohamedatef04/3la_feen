import 'package:ala_feen/core/theme/app_colors.dart';
import 'package:ala_feen/core/theme/app_text_styles.dart';
import 'package:ala_feen/core/utils/validator.dart';
import 'package:ala_feen/features/auth/presentation/cubits/forget_password_cubit/forget_password_cubit.dart';
import 'package:ala_feen/features/auth/presentation/cubits/forget_password_cubit/forget_password_state.dart';
import 'package:ala_feen/features/auth/presentation/widgets/custom_text_form_field.dart';
import 'package:ala_feen/features/auth/presentation/widgets/logo_with_back_button.dart';
import 'package:ala_feen/features/get_started/widgets/custom_button_widget.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});
  static const String routeName = '/forget-password';

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
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
    return BlocListener<ForgetPasswordCubit, ForgetPasswordState>(
      listener: (context, state) {
        if (state is ForgetPasswordSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Password reset link sent! Check your email.'),
            ),
          );
          // Maybe navigate back to login?
          // GoRouter.of(context).pop();
        } else if (state is ForgetPasswordFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage)),
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
                        'نسيت كلمة المرور؟',
                        style: AppTextStyles.bold25(context),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    FadeInRight(
                      delay: const Duration(milliseconds: 200),
                      child: Text(
                        'لا تقلق! أدخل بريدك الإلكتروني أدناه وسنرسل لك تعليمات لإعادة تعيين كلمة المرور.',
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
                            'البريد الإلكتروني',
                            style: AppTextStyles.bold14(context),
                          ),
                          CustomTextFormField(
                            hintText: 'أدخل البريد الإلكتروني',
                            controller:
                                _emailController, // Using email controller for simplicity as per requirement, but UI says Phone/Email
                            keyboardType: TextInputType.emailAddress,
                            validator: Validator
                                .validateEmail, // Assuming email for Supabase reset
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
                      child:
                          BlocBuilder<ForgetPasswordCubit, ForgetPasswordState>(
                            builder: (context, state) {
                              if (state is ForgetPasswordLoading) {
                                return const Center(
                                  child: CircularCircularProgressIndicator(),
                                );
                              }
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
                                      _autoValidateMode =
                                          AutovalidateMode.always;
                                    });
                                  }
                                },
                                child: Text(
                                  'إرسال',
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

// Temporary Indicator fix if CircularProgressIndicator is standard
class CircularCircularProgressIndicator extends StatelessWidget {
  const CircularCircularProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator(color: AppColors.primary);
  }
}
