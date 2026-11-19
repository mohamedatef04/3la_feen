import 'package:ala_feen/core/theme/app_text_styles.dart';
import 'package:ala_feen/features/home/driver/presentation/cubit/driver_ratings/driver_ratings_cubit.dart';
import 'package:ala_feen/features/home/driver/presentation/widgets/driver_details_header.dart';
import 'package:ala_feen/core/cubits/cubit/user_data_cubit.dart';

import 'package:ala_feen/core/di/injection_container.dart';
import 'package:ala_feen/features/home/passenger/data/repos/passenger_home_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:skeletonizer/skeletonizer.dart';

class RatesScreen extends StatelessWidget {
  const RatesScreen({super.key});

  static const String routeName = '/rates';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<DriverRatingsCubit>()..getDriverRatings(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Column(
          children: [
            const DriverDetailsHeader(
              title: 'التقييمات',
            ),
            Expanded(
              child: BlocBuilder<DriverRatingsCubit, DriverRatingsState>(
                builder: (context, state) {
                  if (state is DriverRatingsLoading) {
                    return Skeletonizer(
                      enabled: true,
                      child: ListView.separated(
                        padding: EdgeInsets.all(15.w),
                        itemCount: 6,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 10.h),
                        itemBuilder: (context, index) => _buildRateItem(
                          context,
                          rating: 5,
                          comment: 'هذا نص تجريبي للتحميل...',
                          date: DateTime.now(),
                          passengerId: 'dummy_id',
                        ),
                      ),
                    );
                  } else if (state is DriverRatingsFailure) {
                    return Center(
                      child: Text(
                        state.errorMessage,
                        style: AppTextStyles.regular14(context),
                      ),
                    );
                  } else if (state is DriverRatingsSuccess) {
                    if (state.ratings.isEmpty) {
                      return Center(
                        child: Text(
                          'لا توجد تقييمات بعد',
                          style: AppTextStyles.bold16(context),
                        ),
                      );
                    }
                    return ListView.separated(
                      padding: EdgeInsets.all(15.w),
                      itemCount: state.ratings.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 10.h),
                      itemBuilder: (context, index) {
                        final ratingData = state.ratings[index];
                        final rating = (ratingData['rating'] as num).toInt();
                        final comment = ratingData['comment'] as String?;
                        final date = DateTime.parse(ratingData['created_at']);
                        final passengerId =
                            ratingData['passenger_id'] as String;

                        return _buildRateItem(
                          context,
                          rating: rating,
                          comment: comment,
                          date: date,
                          passengerId: passengerId,
                        );
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRateItem(
    BuildContext context, {
    required int rating,
    String? comment,
    required DateTime date,
    required String passengerId,
  }) {
    return BlocProvider(
      create: (context) =>
          UserDataCubit(sl<PassengerHomeRepo>())..getUserData(passengerId),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
              spreadRadius: 2,
            ),
          ],
          border: Border.all(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                BlocBuilder<UserDataCubit, UserDataState>(
                  builder: (context, state) {
                    if (state is UserDataSuccess) {
                      final user = state.userModel;
                      return Container(
                        width: 45.w,
                        height: 45.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(
                            context,
                          ).primaryColor.withValues(alpha: 0.1),
                          image: user.profilePic != null
                              ? DecorationImage(
                                  image: NetworkImage(user.profilePic!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: user.profilePic == null
                            ? Icon(
                                Icons.person,
                                color: Theme.of(context).primaryColor,
                                size: 24.sp,
                              )
                            : null,
                      );
                    }
                    return Container(
                      width: 45.w,
                      height: 45.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                      ),
                      child: Icon(
                        Icons.person,
                        color: Theme.of(context).primaryColor,
                        size: 24.sp,
                      ),
                    );
                  },
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BlocBuilder<UserDataCubit, UserDataState>(
                        builder: (context, state) {
                          String name = '...';
                          if (state is UserDataSuccess) {
                            name = state.userModel.name ?? 'راكب';
                          }
                          return Text(
                            name,
                            style: AppTextStyles.bold14(context).copyWith(
                              color: Theme.of(
                                context,
                              ).textTheme.bodyLarge?.color,
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < rating
                                ? Icons.star_rounded
                                : Icons.star_outline_rounded,
                            color: Colors.amber,
                            size: 16.sp,
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                Text(
                  DateFormat('yyyy/MM/dd').format(date),
                  style: AppTextStyles.regular12(context).copyWith(
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ],
            ),
            if (comment != null && comment.isNotEmpty) ...[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Divider(
                  height: 1,
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
                ),
              ),
              Text(
                comment,
                style: AppTextStyles.regular14(context).copyWith(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                  height: 1.5,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
