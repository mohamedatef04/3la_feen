import 'package:ala_feen/features/auth/presentation/widgets/reset_password_widgets/reset_password_form.dart';
import 'package:ala_feen/features/auth/presentation/widgets/shared_widgets/logo_with_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});
  static const String routeName = '/reset-password';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                const LogoWithBackButton(),
                SizedBox(height: 40.h),
                const ResetPasswordForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
