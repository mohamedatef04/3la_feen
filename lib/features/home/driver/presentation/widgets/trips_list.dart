import 'package:ala_feen/core/functions/show_snack_bar.dart';
import 'package:ala_feen/features/home/driver/data/models/offer_model.dart';
import 'package:ala_feen/features/home/driver/presentation/cubit/home_driver/home_driver_cubit.dart';
import 'package:ala_feen/features/home/driver/presentation/cubit/trip_action/trip_action_cubit.dart';
import 'package:ala_feen/features/home/driver/presentation/cubit/trip_action/trip_action_state.dart';
import 'package:ala_feen/features/home/driver/presentation/cubit/trips_stream/trips_stream_cubit.dart';
import 'package:ala_feen/features/home/driver/presentation/cubit/trips_stream/trips_stream_state.dart';
import 'package:ala_feen/features/home/driver/presentation/widgets/trip_card.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TripsList extends StatelessWidget {
  const TripsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<TripActionCubit, TripActionState>(
      listener: (context, state) {
        if (state.status == TripActionStatus.failure) {
          showCustomSnackBar(context, state.errorMessage.toString());
        } else if (state.status == TripActionStatus.success) {
          showCustomSnackBar(context, 'تم ارسال التفاوض');
        }
      },
      child: BlocBuilder<TripsStreamCubit, TripsStreamState>(
        builder: (context, state) {
          if (state.status == TripsStreamStatus.loading &&
              (state.trips == null || state.trips!.isEmpty)) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.trips == null || state.trips!.isEmpty) {
            return const Center(child: Text('No trips available'));
          }

          return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: state.trips?.length ?? 0,
            itemBuilder: (context, index) {
              final trip = state.trips![index];
              return FadeInRight(
                child: TripCard(
                  phoneNumber: trip.phoneNumber ?? '',
                  pickupLocation: trip.originAddress ?? '',
                  dropoffLocation: trip.distAddress ?? '',
                  price: trip.tripPrice ?? '',
                  onAccept: () {
                    context.read<TripsStreamCubit>().updateStatus(
                      id: trip.tripId ?? '',
                    );
                  },
                  onNegotiate: (negotiatedPrice) {
                    context.read<TripActionCubit>().makeOffer(
                      offer: OfferModel(
                        tripId: trip.tripId,
                        driverId: context
                            .read<HomeDriverCubit>()
                            .state
                            .userModel
                            ?.id,
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
}
