import 'package:ala_feen/core/theme/app_colors.dart';
import 'package:ala_feen/core/theme/app_text_styles.dart';
import 'package:ala_feen/core/utils/app_strings.dart';
import 'package:ala_feen/features/auth/presentation/screens/forget_password_screen.dart';
import 'package:ala_feen/core/utils/validator.dart';
import 'package:ala_feen/features/auth/presentation/cubits/login_cubit/login_cubit.dart';
import 'package:ala_feen/features/auth/presentation/cubits/login_cubit/login_state.dart';
import 'package:ala_feen/features/auth/presentation/widgets/custom_text_form_field.dart';
import 'package:ala_feen/features/get_started/widgets/custom_button_widget.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class LoginPassengerTextFieldsColumnWidget extends StatefulWidget {
  const LoginPassengerTextFieldsColumnWidget({
    super.key,
  });

  @override
  State<LoginPassengerTextFieldsColumnWidget> createState() =>
      _LoginPassengerTextFieldsColumnWidgetState();
}

class _LoginPassengerTextFieldsColumnWidgetState
    extends State<LoginPassengerTextFieldsColumnWidget> {
  final TextEditingController _passengerEmailController =
      TextEditingController();
  final TextEditingController _passengerPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode autoValidateMode = AutovalidateMode.disabled;

  @override
  void dispose() {
    _passengerEmailController.dispose();
    _passengerPasswordController.dispose();
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
              controller: _passengerEmailController,
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
              controller: _passengerPasswordController,
              obscureText: true,
              validator: Validator.validatePassword,
            ),
          ),

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

          FadeInRight(
            delay: const Duration(milliseconds: 800),
            child: BlocBuilder<LoginCubit, LoginState>(
              builder: (context, state) {
                if (state is LoginLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                }
                return CustomButtonWidget(
                  backgroundColor: AppColors.primary,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      context.read<LoginCubit>().loginUser(
                        email: _passengerEmailController.text.trim(),
                        password: _passengerPasswordController.text.trim(),
                      );
                    } else {
                      setState(() {
                        autoValidateMode = AutovalidateMode.always;
                      });
                    }
                  },
                  child: Text(
                    AppStrings.login,
                    style: AppTextStyles.bold16(context),
                  ),
                );
              },
            ),
          ),

          // Submit Button
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
