import 'package:ala_feen/core/theme/app_colors.dart';
import 'package:ala_feen/features/home/passenger/presentation/widgets/location_widgets/location_input_fields.dart';
import 'package:ala_feen/features/home/passenger/presentation/widgets/location_widgets/location_popup_header.dart';
import 'package:ala_feen/features/home/passenger/presentation/widgets/location_widgets/choose_on_map_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RideLocationPopup extends StatelessWidget {
  const RideLocationPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const LocationPopupHeader(),
              SizedBox(height: 30.h),
              const LocationInputFields(),
              SizedBox(height: 15.h),
              ChooseOnMapButton(
                onTap: () {
                  // Handle choose on map
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
