import 'package:ala_feen/core/functions/show_snack_bar.dart';
import 'package:ala_feen/core/theme/app_text_styles.dart';
import 'package:ala_feen/features/home/driver/presentation/cubit/home_driver/home_driver_cubit.dart';
import 'package:ala_feen/features/home/driver/presentation/cubit/trip_action/trip_action_cubit.dart';
import 'package:ala_feen/features/home/driver/presentation/cubit/trip_action/trip_action_state.dart';
import 'package:ala_feen/features/home/driver/presentation/cubit/trips_stream/trips_stream_cubit.dart';
import 'package:ala_feen/features/home/driver/presentation/cubit/trips_stream/trips_stream_state.dart';
import 'package:ala_feen/features/home/driver/presentation/screens/driver_offer_accepted_screen.dart';
import 'package:ala_feen/features/home/driver/presentation/widgets/trip_card.dart';
import 'package:ala_feen/features/home/passenger/data/models/offer_model.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:ala_feen/core/utils/responsive.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TripsList extends StatelessWidget {
  const TripsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<TripActionCubit, TripActionState>(
      listenWhen: (previous, current) =>
          previous.status != current.status ||
          previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        if (state.status == TripActionStatus.failure) {
          showCustomSnackBar(context, state.errorMessage.toString());
        } else if (state.status == TripActionStatus.pending) {
          showCustomSnackBar(context, 'تم الارسال');
        } else if (state.status == TripActionStatus.accepted) {
          showCustomSnackBar(context, 'تم قبول العرض');
          if (state.trip != null) {
            context.push(
              DriverOfferAcceptedScreen.routeName,
              extra: state.trip,
            );
          }
        } else if (state.status == TripActionStatus.rejected) {
          showCustomSnackBar(context, 'تم رفض العرض');
        }
      },
      child: BlocBuilder<TripsStreamCubit, TripsStreamState>(
        builder: (context, state) {
          if (state.status == TripsStreamStatus.loading &&
              (state.trips == null || state.trips!.isEmpty)) {
            // Show skeleton loading
            return _buildResponsiveList(
              itemCount: 5,
              itemBuilder: (context, index) => Skeletonizer(
                enabled: true,
                child: TripCard(
                  passengerId: 'dummy_id',
                  pickupLocation: 'موقع الانطلاق المتوقع',
                  dropoffLocation: 'الوجهة المتوقعة للرحلة',
                  price: '150',
                  onAccept: () {},
                  onNegotiate: (_) {},
                ),
              ),
            );
          }

          if (state.trips == null || state.trips!.isEmpty) {
            return Center(
              child: Text(
                'لا توجد رحلات متاحة',
                style: AppTextStyles.bold14(context),
              ),
            );
          }

          return _buildResponsiveList(
            itemCount: state.trips!.length,
            itemBuilder: (context, index) {
              final trip = state.trips![index];
              return FadeInRight(
                child: TripCard(
                  passengerId: trip.passengerId ?? '',
                  pickupLocation: trip.originAddress ?? '',
                  dropoffLocation: trip.distAddress ?? '',
                  price: trip.tripPrice.toString(),
                  onAccept: () {
                    context.read<TripActionCubit>().makeOffer(
                      trip: trip,
                      offer: OfferModel(
                        tripId: trip.tripId,
                        driverId: context
                            .read<HomeDriverCubit>()
                            .state
                            .userModel
                            ?.id,
                        offerPrice: trip.tripPrice,
                        status: 'pending',
                      ),
                    );
                  },
                  onNegotiate: (negotiatedPrice) {
                    context.read<TripActionCubit>().makeOffer(
                      trip: trip,
                      offer: OfferModel(
                        tripId: trip.tripId,
                        driverId: context
                            .read<HomeDriverCubit>()
                            .state
                            .userModel
                            ?.id,
                        status: 'pending',
                        offerPrice: negotiatedPrice,
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildResponsiveList({
    required int itemCount,
    required Widget Function(BuildContext, int) itemBuilder,
  }) {
    return Responsive(
      mobile: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: itemCount,
        itemBuilder: itemBuilder,
      ),
      tablet: GridView.builder(
        padding: EdgeInsets.all(16.w),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.2,
          crossAxisSpacing: 16.w,
          mainAxisSpacing: 16.h,
        ),
        itemCount: itemCount,
        itemBuilder: itemBuilder,
      ),
    );
  }
}
