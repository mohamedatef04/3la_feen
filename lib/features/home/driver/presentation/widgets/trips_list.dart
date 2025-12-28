import 'package:ala_feen/features/home/driver/presentation/widgets/trip_card.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class TripsList extends StatelessWidget {
  const TripsList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: 10,
      itemBuilder: (context, index) {
        return FadeInRight(
          child: TripCard(
            phoneNumber: index == 1 ? '01200936120' : '0123456789',
            pickupLocation: 'بنزينه موبيل منطقه البطاش',
            dropoffLocation: 'موقف الاتوبيسات الكيلو 21',
            price: '20',
            onAccept: () {},
          ),
        );
      },
    );
  }
}
