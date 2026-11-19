import 'package:ala_feen/core/theme/app_text_styles.dart';
import 'package:ala_feen/features/home/passenger/data/models/offer_model.dart';
import 'package:ala_feen/features/home/passenger/presentation/cubits/get_driver_data_cubit/get_driver_data_cubit.dart';
import 'package:ala_feen/features/home/passenger/presentation/cubits/get_trip_details_cubit/get_trip_details_cubit.dart';
import 'package:ala_feen/features/home/passenger/presentation/widgets/accepted_offer_widgets/bottom_action_buttons.dart';
import 'package:ala_feen/features/home/passenger/presentation/widgets/accepted_offer_widgets/driver_info_card.dart';
import 'package:ala_feen/features/home/passenger/presentation/widgets/accepted_offer_widgets/estimated_arrival_card.dart';
import 'package:ala_feen/features/home/passenger/presentation/widgets/accepted_offer_widgets/success_icon_widget.dart';
import 'package:ala_feen/features/home/passenger/presentation/widgets/accepted_offer_widgets/trip_details_card.dart';
import 'package:ala_feen/features/home/passenger/presentation/cubits/passenger_trip_monitor_cubit/passenger_trip_monitor_cubit.dart';
import 'package:ala_feen/core/di/injection_container.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AcceptOfferScreen extends StatefulWidget {
  final OfferModel offer;
  static const String routeName = '/accept_offer';

  const AcceptOfferScreen({super.key, required this.offer});

  @override
  State<AcceptOfferScreen> createState() => _AcceptOfferScreenState();
}

class _AcceptOfferScreenState extends State<AcceptOfferScreen> {
  @override
  void initState() {
    context.read<GetDriverDataCubit>().getDriverData(widget.offer.driverId!);
    context.read<GetTripDetailsCubit>().getTripDetails(widget.offer.tripId!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'تفاصيل الرحلة',
          style: AppTextStyles.bold18(context),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: BlocProvider(
          create: (context) =>
              sl<PassengerTripMonitorCubit>()
                ..monitorTrip(widget.offer.tripId!),
          child:
              BlocListener<
                PassengerTripMonitorCubit,
                PassengerTripMonitorState
              >(
                listener: (context, state) {
                  if (state.status == PassengerTripStatus.cancelled) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم إلغاء الرحلة')),
                    );
                    context.go('/passenger-home');
                  }
                },
                child: BlocBuilder<GetDriverDataCubit, GetDriverDataState>(
                  builder: (context, driverState) {
                    final driverName = driverState is GetDriverDataSuccess
                        ? driverState.driverModel.name
                        : null;
                    final driverPhone = driverState is GetDriverDataSuccess
                        ? driverState.driverModel.phone
                        : null;

                    return BlocBuilder<
                      GetTripDetailsCubit,
                      GetTripDetailsState
                    >(
                      builder: (context, tripState) {
                        final trip = tripState is GetTripDetailsSuccess
                            ? tripState.trip
                            : null;

                        return Column(
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                padding: EdgeInsets.symmetric(horizontal: 20.w),
                                child: Column(
                                  children: [
                                    SizedBox(height: 20.h),
                                    const SuccessIconWidget(),
                                    SizedBox(height: 24.h),
                                    Text(
                                      'تم قبول العرض بنجاح!',
                                      style: AppTextStyles.bold25(context),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 8.h),
                                    Text(
                                      'الكابتن في الطريق إليك',
                                      style: AppTextStyles.regular14(context)
                                          .copyWith(
                                            color: Theme.of(context).hintColor,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 32.h),
                                    DriverInfoCard(
                                      tripId: widget.offer.tripId!,
                                    ),
                                    SizedBox(height: 16.h),
                                    const TripDetailsCard(),
                                    SizedBox(height: 16.h),
                                    const EstimatedArrivalCard(),
                                    SizedBox(height: 24.h),
                                  ],
                                ),
                              ),
                            ),
                            BottomActionButtons(
                              trip: trip,
                              driverName: driverName,
                              driverPhone: driverPhone,
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
        ),
      ),
    );
  }
}
