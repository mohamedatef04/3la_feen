import 'package:ala_feen/core/theme/app_colors.dart';
import 'package:ala_feen/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class UseMyCurrentLocationWidget extends StatelessWidget {
  const UseMyCurrentLocationWidget({
    super.key,

    this.onTap,
  });

  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(Icons.location_on, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            'استخدم موقعي الحالي',
            style: AppTextStyles.regular14(
              context,
            ).copyWith(color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}
