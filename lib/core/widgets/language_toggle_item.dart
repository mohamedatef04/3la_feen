import 'package:ala_feen/core/theme/app_text_styles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Drawer row that switches the app between Arabic and English.
/// The label shows the language you will switch to.
class LanguageToggleItem extends StatelessWidget {
  const LanguageToggleItem({super.key});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final isArabic = context.locale.languageCode == 'ar';

    return InkWell(
      onTap: () => context.setLocale(Locale(isArabic ? 'en' : 'ar')),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
        child: Row(
          children: [
            Icon(Icons.language, color: primary, size: 24.sp),
            SizedBox(width: 15.w),
            Text(
              'menu.language'.tr(),
              style: AppTextStyles.bold16(context).copyWith(color: primary),
            ),
          ],
        ),
      ),
    );
  }
}
