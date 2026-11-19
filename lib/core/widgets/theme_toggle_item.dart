import 'package:ala_feen/core/cubits/cubit/theme_toggle_cubit.dart';

import 'package:ala_feen/core/theme/app_text_styles.dart';
import 'package:ala_feen/core/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ThemeToggleItem extends StatelessWidget {
  const ThemeToggleItem({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeToggleCubit, ThemeData>(
      builder: (context, state) {
        final isDarkMode = state.brightness == Brightness.dark;
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 15.w,
            vertical: 10.h,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.brightness_6_outlined,
                    color: Theme.of(context).colorScheme.primary,
                    size: 24.sp,
                  ),
                  SizedBox(width: 15.w),
                  Text(
                    AppStrings.darkMode,
                    style: AppTextStyles.bold16(context).copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              Switch(
                value: isDarkMode,
                onChanged: (value) {
                  context.read<ThemeToggleCubit>().toggleTheme();
                },
                activeColor: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        );
      },
    );
  }
}
