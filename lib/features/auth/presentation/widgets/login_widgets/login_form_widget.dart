import 'dart:developer';

import 'package:ala_feen/core/theme/app_colors.dart';
import 'package:ala_feen/core/theme/app_text_styles.dart';
import 'package:ala_feen/core/utils/app_strings.dart';
import 'package:ala_feen/core/functions/show_snack_bar.dart';
import 'package:ala_feen/features/auth/presentation/screens/forget_password_screen.dart';
import 'package:ala_feen/core/utils/validator.dart';
import 'package:ala_feen/features/auth/presentation/cubits/login_cubit/login_cubit.dart';
import 'package:ala_feen/features/auth/presentation/cubits/login_cubit/login_state.dart';
import 'package:ala_feen/features/auth/presentation/widgets/shared_widgets/custom_text_form_field.dart';
import 'package:ala_feen/features/get_started/widgets/custom_button_widget.dart';
import 'package:ala_feen/features/home/passenger/presentation/screens/passenger_home_screen.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ala_feen/features/home/driver/presentation/screens/driver_home_screen.dart';
import 'package:go_router/go_router.dart';

class LoginFormWidget extends StatefulWidget {
  const LoginFormWidget({
    super.key,
  });

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isObscured = true;
  AutovalidateMode autoValidateMode = AutovalidateMode.disabled;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: autoValidateMode,
      child: Column(
        spacing: 15.h,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Email Field
          FadeInRight(
            delay: const Duration(milliseconds: 200),
            child: _buildFieldWithHeader(
              context: context,
              headerText: AppStrings.email,
              hintText: 'أدخل ${AppStrings.email}',
              icon: Icons.email_outlined,
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              validator: Validator.validateEmail,
            ),
          ),

          // Password Field
          FadeInRight(
            delay: const Duration(milliseconds: 400),
            child: _buildFieldWithHeader(
              context: context,
              headerText: AppStrings.password,
              hintText: 'أدخل ${AppStrings.password}',
              icon: Icons.lock_outline,
              controller: _passwordController,
              validator: Validator.validatePassword,
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _isObscured = !_isObscured;
                  });
                },
                icon: _isObscured
                    ? const Icon(Icons.visibility_off_outlined)
                    : const Icon(Icons.visibility_outlined),
              ),
              obscureText: _isObscured,
            ),
          ),

          // Forgot Password
          FadeInRight(
            delay: const Duration(milliseconds: 600),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {
                  GoRouter.of(context).push(ForgetPasswordScreen.routeName);
                },
                child: Text(
                  'هل نسيت كلمة المرور؟',
                  style: AppTextStyles.medium14(context).copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ),

          // Login Button
          FadeInRight(
            delay: const Duration(milliseconds: 800),
            child: BlocConsumer<LoginCubit, LoginState>(
              listener: (context, state) {
                if (state is LoginSuccess) {
                  showCustomSnackBar(context, AppStrings.loginSuccessful);
                  // Navigate based on role
                  if (state.role == 'driver') {
                    GoRouter.of(context).go(DriverHomeScreen.routeName);
                  } else {
                    GoRouter.of(context).go(PassengerHomeScreen.routeName);
                  }
                  log('userId ${state.userId}, role ${state.role}');
                } else if (state is LoginFailure) {
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
                      context.read<LoginCubit>().loginUser(
                        email: _emailController.text.trim(),
                        password: _passwordController.text.trim(),
                      );
                    } else {
                      setState(() {
                        autoValidateMode = AutovalidateMode.always;
                      });
                    }
                  },
                  child: state is LoginLoading
                      ? const CupertinoActivityIndicator(color: AppColors.white)
                      : Text(
                          AppStrings.login,
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

  Widget _buildFieldWithHeader({
    required BuildContext context,
    required String headerText,
    required String hintText,
    required IconData icon,
    TextEditingController? controller,
    TextInputType? keyboardType,
    Widget? suffixIcon,
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
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}
