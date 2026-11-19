import 'package:flutter/material.dart';

class MapSkeletonLoader extends StatelessWidget {
  const MapSkeletonLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors
          .grey[200], // Simple background color, Skeletonizer will animate the shimmer over it
    );
  }
}
