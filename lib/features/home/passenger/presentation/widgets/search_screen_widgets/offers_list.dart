import 'package:ala_feen/features/home/passenger/presentation/cubits/get_offers_stream_cubit/get_prices_offers_cubit.dart';
import 'package:ala_feen/features/home/passenger/presentation/widgets/search_screen_widgets/offer_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OffersList extends StatelessWidget {
  final num requestedPrice;
  const OffersList({super.key, required this.requestedPrice});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetPricesOffersCubit, GetPricesOffersState>(
      builder: (context, state) {
        if (state is GetPricesOffersSuccess) {
          if (state.offers.isEmpty) {
            return const Center();
          }
          return ListView.builder(
            itemCount: state.offers.length,
            padding: EdgeInsets.only(top: 10.h),
            itemBuilder: (context, index) {
              return OfferItem(
                offer: state.offers[index],
                requestedPrice: requestedPrice,
              );
            },
          );
        }
        return const Center();
      },
    );
  }
}
