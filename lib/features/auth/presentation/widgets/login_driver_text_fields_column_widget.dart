import 'package:ala_feen/core/theme/app_colors.dart';
import 'package:ala_feen/core/theme/app_text_styles.dart';
import 'package:ala_feen/core/utils/app_strings.dart';
import 'package:ala_feen/core/utils/validator.dart';
import 'package:ala_feen/features/auth/presentation/widgets/custom_text_form_field.dart';
import 'package:ala_feen/features/get_started/widgets/custom_button_widget.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginDriverTextFieldsColumnWidget extends StatefulWidget {
  const LoginDriverTextFieldsColumnWidget({
    super.key,
  });

  @override
  State<LoginDriverTextFieldsColumnWidget> createState() =>
      _LoginDriverTextFieldsColumnWidgetState();
}

class _LoginDriverTextFieldsColumnWidgetState
    extends State<LoginDriverTextFieldsColumnWidget> {
  final TextEditingController _driverEmailController = TextEditingController();
  final TextEditingController _driverPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode autoValidateMode = AutovalidateMode.disabled;

  @override
  void dispose() {
    _driverEmailController.dispose();
    _driverPasswordController.dispose();
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
              headerText: AppStrings.phoneNumber,
              hintText: 'أدخل ${AppStrings.phoneNumber}',
              icon: Icons.phone_android_outlined,
              controller: _driverEmailController,
              keyboardType: TextInputType.phone,
              validator: Validator.validatePhone,
            ),
          ),
          FadeInRight(
            delay: const Duration(milliseconds: 400),
            child: _buildFieldWithHeader(
              context: context,
              headerText: AppStrings.password,
              hintText: 'أدخل ${AppStrings.password}',
              icon: Icons.lock_outline,
              controller: _driverPasswordController,
              obscureText: true,
              validator: Validator.validatePassword,
            ),
          ),

          FadeInRight(
            delay: const Duration(milliseconds: 600),
            child: CustomButtonWidget(
              backgroundColor: AppColors.primary,
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
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
