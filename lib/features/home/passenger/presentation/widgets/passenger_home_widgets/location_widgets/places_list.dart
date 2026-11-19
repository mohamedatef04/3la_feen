import 'package:ala_feen/core/theme/app_text_styles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ala_feen/features/home/passenger/data/models/place_model.dart';
import 'package:ala_feen/features/home/passenger/presentation/cubits/get_places_cubit/get_places_cubit.dart';
import 'package:ala_feen/features/home/passenger/presentation/widgets/passenger_home_widgets/location_widgets/place_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlacesList extends StatelessWidget {
  const PlacesList({super.key, required this.onTap});
  final void Function(PlaceModel) onTap;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetPlacesCubit, GetPlacesState>(
      builder: (context, state) {
        if (state is GetPlacesInitial) {
          return const SizedBox.shrink();
        } else if (state is GetPlacesLoading) {
          return Center(
            child: CupertinoActivityIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
          );
        } else if (state is GetPlacesSuccess) {
          if (state.places.isEmpty) {
            return Center(
              child: Text(
                'passenger.no_places'.tr(),
                style: AppTextStyles.bold16(
                  context,
                ).copyWith(color: Theme.of(context).colorScheme.primary),
              ),
            );
          }
          return ListView.separated(
            itemCount: state.places.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              return PlaceItem(
                place: state.places[index],
                onTap: () => onTap(state.places[index]),
              );
            },
          );
        } else if (state is GetPlacesFailure) {
          return Center(
            child: Text(
              state.errorMessage,
              style: AppTextStyles.bold16(
                context,
              ).copyWith(color: Theme.of(context).colorScheme.primary),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
