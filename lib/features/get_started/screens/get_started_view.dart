import 'package:ala_feen/core/theme/app_colors.dart';
import 'package:ala_feen/core/theme/app_text_styles.dart';
import 'package:ala_feen/core/utils/app_strings.dart';
import 'package:ala_feen/core/widgets/logo_widget.dart';
import 'package:ala_feen/features/auth/presentation/screens/login_screen.dart';
import 'package:ala_feen/features/auth/presentation/screens/register_screen.dart';
import 'package:ala_feen/features/get_started/widgets/custom_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:ala_feen/assets.dart';

class GetStartedView extends StatefulWidget {
  const GetStartedView({super.key});

  @override
  State<GetStartedView> createState() => _GetStartedViewState();
}

class _GetStartedViewState extends State<GetStartedView> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Precache the login image so it's ready when the user navigates to LoginScreen
    precacheImage(AssetImage(Assets.icons.login_image_png), context);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: width,
          child: Column(
            children: [
              Expanded(
                child: LogoWidget(
                  height: 100.h,
                ),
              ),
              Expanded(
                child: Column(
                  spacing: 20.h,
                  children: [
                    CustomButtonWidget(
                      onPressed: () {
                        context.push(RegisterScreen.routeName);
                      },
                      backgroundColor: AppColors.primary,
                      child: Text(
                        AppStrings.newUser,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bold16(context),
                      ),
                    ),
                    CustomButtonWidget(
                      onPressed: () {
                        context.push(LoginScreen.routeName);
                      },
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.primaryContainer,
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                      child: Text(
                        AppStrings.login,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.semiBold16(context),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
