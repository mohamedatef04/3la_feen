import 'package:ala_feen/assets.dart';
import 'package:ala_feen/features/auth/presentation/widgets/login_widgets/login_form_widget.dart';
import 'package:ala_feen/features/auth/presentation/widgets/shared_widgets/logo_with_back_button.dart';
import 'package:ala_feen/core/utils/responsive_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const String routeName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late Image _loginImage;

  @override
  void initState() {
    super.initState();
    _loginImage = Image.asset(
      Assets.images.adobe_file_png,
      gaplessPlayback: true,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) return child;
        return AnimatedOpacity(
          opacity: frame == null ? 0 : 1,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
          child: child,
        );
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(_loginImage.image, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ResponsiveContainer(
          maxWidth: 500,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                spacing: 20.h,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const LogoWithBackButton(),
                  _loginImage,
                  const LoginFormWidget(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
