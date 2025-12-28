import 'package:ala_feen/core/utils/app_strings.dart';
import 'package:ala_feen/features/home/passenger/presentation/widgets/drawer_widgets/drawer_header_profile.dart';
import 'package:ala_feen/features/home/passenger/presentation/widgets/drawer_widgets/drawer_item.dart';
import 'package:ala_feen/features/home/passenger/presentation/widgets/drawer_widgets/theme_toggle_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomPassengerDrawer extends StatelessWidget {
  const CustomPassengerDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250.w,
      backgroundColor: const Color(0xffE0E0E0),
      child: Column(
        children: [
          const DrawerHeaderProfile(),
          Expanded(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                children: [
                  DrawerItem(
                    icon: Icons.account_balance_wallet_outlined,
                    title: AppStrings.paymentMethods,
                    onTap: () {},
                  ),
                  DrawerItem(
                    icon: Icons.notifications_none,
                    title: AppStrings.notifications,
                    onTap: () {},
                  ),
                  DrawerItem(
                    icon: Icons.local_offer_outlined,
                    title: AppStrings.offers,
                    onTap: () {},
                  ),
                  DrawerItem(
                    icon: Icons.history,
                    title: AppStrings.history,
                    onTap: () {},
                  ),
                  DrawerItem(
                    icon: Icons.logout,
                    title: AppStrings.logout,
                    onTap: () {},
                  ),
                  const Divider(),
                  const ThemeToggleItem(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
