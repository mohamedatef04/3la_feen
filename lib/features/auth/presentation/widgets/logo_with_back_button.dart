import 'package:ala_feen/core/widgets/logo_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class LogoWithBackButton extends StatelessWidget {
  const LogoWithBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        Expanded(
          child: LogoWidget(
            height: 50.h,
          ),
        ),
        SizedBox(width: 48.w), // Balance the back button
      ],
    );
  }
}
