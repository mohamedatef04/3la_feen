import 'package:ala_feen/core/theme/app_text_styles.dart';
import 'package:ala_feen/features/home/passenger/data/models/place_model.dart';
import 'package:flutter/material.dart';

class PlaceItem extends StatelessWidget {
  const PlaceItem({super.key, required this.place, required this.onTap});

  final PlaceModel place;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.location_on,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      title: Text(
        place.name?.split(',').first ?? '',
        style: AppTextStyles.bold16(context).copyWith(
          color: Theme.of(context).colorScheme.primary,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        place.displayName ?? '',
        style: AppTextStyles.regular14(context),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
