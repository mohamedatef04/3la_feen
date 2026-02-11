import 'package:ala_feen/features/auth/presentation/widgets/register_widgets/register_driver_form_widget.dart';
import 'package:ala_feen/features/auth/presentation/widgets/register_widgets/register_passenger_form_widget.dart';
import 'package:ala_feen/features/auth/presentation/widgets/login_widgets/driver_and_passenger_toggle_widget.dart';
import 'package:ala_feen/features/auth/presentation/widgets/shared_widgets/logo_with_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ala_feen/core/utils/responsive_container.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  static const String routeName = '/register';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Role selection state
  bool _isPassenger = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ResponsiveContainer(
          maxWidth: 500,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                spacing: 10.h,
                children: [
                  const LogoWithBackButton(),
                  DriverAndPassengerToggleWidget(
                    initialIsPassenger: _isPassenger,
                    onRoleChanged: (isPassenger) {
                      setState(() {
                        _isPassenger = isPassenger;
                      });
                    },
                  ),
                  if (_isPassenger)
                    const RegisterPassengerFormWidget()
                  else
                    const RegisterDriverFormWidget(),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
