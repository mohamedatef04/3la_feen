import 'package:ala_feen/core/theme/app_text_styles.dart';
import 'package:ala_feen/features/home/driver/presentation/cubit/active_trip/active_trip_monitor_cubit.dart';
import 'package:ala_feen/features/home/passenger/data/models/trip_model.dart';
import 'package:ala_feen/features/home/passenger/presentation/widgets/accepted_offer_widgets/success_icon_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'active_trip_map_screen.dart';

class DriverOfferAcceptedScreen extends StatefulWidget {
  static const String routeName = '/driver-offer-accepted';
  final TripModel trip;

  const DriverOfferAcceptedScreen({super.key, required this.trip});

  @override
  State<DriverOfferAcceptedScreen> createState() =>
      _DriverOfferAcceptedScreenState();
}

class _DriverOfferAcceptedScreenState extends State<DriverOfferAcceptedScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            const SuccessIconWidget(),
            SizedBox(height: 24.h),
            Text(
              'تم قبول عرضك!',
              style: AppTextStyles.bold25(context),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              'الركاب في انتظارك الآن',
              style: AppTextStyles.regular16(context).copyWith(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[400]
                    : Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildStepItem(
                      context,
                      icon: Icons.location_on,
                      color: Colors.green,
                      label: 'نقطة الانطلاق',
                      value: widget.trip.originAddress ?? 'غير محدد',
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      child: Divider(
                        color: Theme.of(context).dividerColor,
                        thickness: 1,
                      ),
                    ),
                    _buildStepItem(
                      context,
                      icon: Icons.flag_rounded,
                      color: Colors.red,
                      label: 'وجهة الوصول',
                      value: widget.trip.distAddress ?? 'غير محدد',
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      child: Divider(
                        color: Theme.of(context).dividerColor,
                        thickness: 1,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildInfoColumn(
                          context,
                          'السعر المتوقع',
                          '${widget.trip.tripPrice} ج.م',
                          Icons.payments_outlined,
                          Colors.amber[800]!,
                        ),
                        _buildInfoColumn(
                          context,
                          'المسافة',
                          widget.trip.tripDistance ?? '--',
                          Icons.straighten_outlined,
                          Colors.blue[700]!,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.all(24.w),
              child: ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () async {
                        setState(() {
                          _isLoading = true;
                        });

                        // Small delay to ensure the indicator is visible before the heavy map build
                        await Future.delayed(const Duration(milliseconds: 100));

                        if (!context.mounted) return;

                        context.read<ActiveTripMonitorCubit>().setActiveTrip(
                          widget.trip,
                        );

                        if (context.mounted) {
                          context.pushReplacement(
                            ActiveTripMapScreen.routeName,
                            extra: widget.trip,
                          );
                        }

                        // We don't necessarily need to set _isLoading to false here
                        // because we're using pushReplacement, but it's good practice.
                        if (mounted) {
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  minimumSize: Size(double.infinity, 56.h),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
                child: _isLoading
                    ? const CupertinoActivityIndicator(color: Colors.white)
                    : Text(
                        'التوجه إلى الخريطة',
                        style: AppTextStyles.bold18(
                          context,
                        ).copyWith(color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepItem(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20.w),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.regular12(context).copyWith(
                  color: Theme.of(context).hintColor,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                value,
                style: AppTextStyles.semiBold14(context).copyWith(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoColumn(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18.w),
        SizedBox(width: 8.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.regular10(context).copyWith(
                color: Theme.of(context).hintColor,
              ),
            ),
            Text(
              value,
              style: AppTextStyles.bold14(context).copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
