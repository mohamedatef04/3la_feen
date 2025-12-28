import 'package:ala_feen/assets.dart';
import 'package:ala_feen/features/auth/presentation/widgets/driver_and_passenger_toggle_widget.dart';
import 'package:ala_feen/features/auth/presentation/widgets/login_driver_text_fields_column_widget.dart';
import 'package:ala_feen/features/auth/presentation/widgets/login_passenger_text_fields_column_widget.dart';
import 'package:ala_feen/features/auth/presentation/widgets/logo_with_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const String routeName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Auto validate mode
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;

  // Role selection state
  bool _isPassenger = false;

  late Image _loginImage;

  @override
  void initState() {
    super.initState();
    _loginImage = Image.asset(
      Assets.icons.login_image_png,
      gaplessPlayback: true,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(_loginImage.image, context);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: width,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.h),
              child: Form(
                key: _formKey,
                autovalidateMode: _autoValidateMode,
                child: Column(
                  spacing: 20.h,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const LogoWithBackButton(),
                    DriverAndPassengerToggleWidget(
                      initialIsPassenger: _isPassenger,
                      onRoleChanged: (isPassenger) {
                        setState(() {
                          _isPassenger = isPassenger;
                          _autoValidateMode = AutovalidateMode.disabled;
                        });
                      },
                    ),
                    _loginImage,
                    // Conditionally show passenger or driver form
                    if (_isPassenger)
                      const LoginPassengerTextFieldsColumnWidget()
                    else
                      const LoginDriverTextFieldsColumnWidget(),
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
