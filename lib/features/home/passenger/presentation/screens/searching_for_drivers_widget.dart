import 'package:ala_feen/core/theme/app_text_styles.dart';
import 'package:ala_feen/features/home/passenger/data/models/trip_model.dart';
import 'package:ala_feen/features/home/passenger/presentation/cubits/get_offers_stream_cubit/get_prices_offers_cubit.dart';
import 'package:ala_feen/features/home/passenger/presentation/widgets/search_screen_widgets/offers_list.dart';
import 'package:ala_feen/features/home/passenger/presentation/widgets/search_screen_widgets/ripple_searching_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchingForDriversScreen extends StatefulWidget {
  final TripModel tripModel;
  const SearchingForDriversScreen({super.key, required this.tripModel});
  static String routeName = '/searching_for_drivers';

  @override
  State<SearchingForDriversScreen> createState() =>
      _SearchingForDriversScreenState();
}

class _SearchingForDriversScreenState extends State<SearchingForDriversScreen> {
  bool findDriver = false;
  int offers = 0;

  @override
  void initState() {
    super.initState();
    if (widget.tripModel.tripId != null) {
      context.read<GetPricesOffersCubit>().listenToOffers(
        widget.tripModel.tripId!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GetPricesOffersCubit, GetPricesOffersState>(
      listener: (context, state) {
        if (state is GetPricesOffersSuccess && state.offers.isNotEmpty) {
          setState(() {
            findDriver = true;
          });
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            const RippleSearchingAnimation(),
            // Debug Trip ID and Status
            Positioned(
              top: 50.h,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Text(
                    'جاري البحث عن كابتن...',
                    style: AppTextStyles.bold18(context),
                  ),
                  findDriver
                      ? BlocBuilder<GetPricesOffersCubit, GetPricesOffersState>(
                          builder: (context, state) {
                            if (state is GetPricesOffersSuccess) {
                              if (state.offers.isNotEmpty) {
                                offers = state.offers.length;
                              }
                            }
                            return Text(
                              'لديك $offers عروض حتي الآن',
                              style: AppTextStyles.regular12(context).copyWith(
                                color: Colors.grey,
                              ),
                            );
                          },
                        )
                      : Text(
                          'متصل وبانتظار العروض...',
                          style: AppTextStyles.regular12(context).copyWith(
                            color: Colors.grey,
                          ),
                        ),
                ],
              ),
            ),
            if (findDriver)
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.45,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30.r),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: OffersList(
                    requestedPrice: widget.tripModel.tripPrice ?? 0,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
