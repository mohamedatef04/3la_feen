import 'package:ala_feen/core/di/injection_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ala_feen/core/cubits/notifications/notifications_cubit.dart';
import 'package:ala_feen/core/models/notification_model.dart';
import 'package:ala_feen/core/theme/app_colors.dart';
import 'package:ala_feen/core/theme/app_text_styles.dart';
import 'package:ala_feen/features/home/driver/presentation/widgets/driver_details_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  static const String routeName = '/notifications';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<NotificationsCubit>()..getNotifications(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Column(
          children: [
            DriverDetailsHeader(
              title: 'notifications.title'.tr(),
            ),
            Expanded(
              child: BlocBuilder<NotificationsCubit, NotificationsState>(
                builder: (context, state) {
                  if (state is NotificationsLoading) {
                    return Skeletonizer(
                      enabled: true,
                      child: ListView.separated(
                        padding: EdgeInsets.all(15.w),
                        itemCount: 6,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 10.h),
                        itemBuilder: (context, index) {
                          return _buildNotificationItem(
                            context,
                            NotificationModel(
                              id: '1',
                              title: 'placeholder.title'.tr(),
                              body: 'placeholder.body'.tr(),
                              createdAt: DateTime.now(),
                              isRead: false,
                              type: 'system',
                            ),
                          );
                        },
                      ),
                    );
                  }

                  if (state is NotificationsFailure) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64.sp,
                            color: AppColors.greyColor,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'errors.load_notifications'.tr(),
                            style: AppTextStyles.regular14(context).copyWith(
                              color: AppColors.greyColor,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          TextButton(
                            onPressed: () {
                              context
                                  .read<NotificationsCubit>()
                                  .getNotifications();
                            },
                            child: Text(
                              'common.retry'.tr(),
                              style: AppTextStyles.bold14(context).copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is NotificationsSuccess) {
                    if (state.notifications.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.notifications_off_outlined,
                              size: 64.sp,
                              color: AppColors.greyColor,
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              'notifications.empty'.tr(),
                              style: AppTextStyles.regular14(context).copyWith(
                                color: AppColors.greyColor,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<NotificationsCubit>().getNotifications();
                      },
                      child: ListView.separated(
                        padding: EdgeInsets.all(15.w),
                        itemCount: state.notifications.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 10.h),
                        itemBuilder: (context, index) {
                          return _buildNotificationItem(
                            context,
                            state.notifications[index],
                          );
                        },
                      ),
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

  Widget _buildNotificationItem(
    BuildContext context,
    NotificationModel notification,
  ) {
    return Container(
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: notification.isRead == true
            ? Theme.of(context).cardColor
            : AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: notification.isRead == false
            ? Border.all(
                color: AppColors.primary.withValues(alpha: 0.2),
                width: 1,
              )
            : null,
      ),
      child: InkWell(
        onTap: () {
          if (notification.id != null && notification.isRead == false) {
            context.read<NotificationsCubit>().markAsRead(notification.id!);
          }
        },
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              child: Text(
                _formatTime(notification.createdAt),
                style: AppTextStyles.regular10(context).copyWith(
                  color: AppColors.greyColor,
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _getNotificationIcon(notification.type),
                SizedBox(width: 15.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.title ??
                            'notifications.default_title'.tr(),
                        style: AppTextStyles.bold14(context).copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        notification.body ?? '',
                        style: AppTextStyles.regular12(context).copyWith(
                          color: AppColors.greyColor,
                        ),
                      ),
                    ],
                  ),
                ),
                if (notification.isRead == false)
                  Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _getNotificationIcon(String? type) {
    IconData iconData;
    Color iconColor;

    switch (type) {
      case 'trip':
        iconData = Icons.directions_car;
        iconColor = AppColors.primary;
        break;
      case 'offer':
        iconData = Icons.local_offer;
        iconColor = Colors.orange;
        break;
      case 'promo':
        iconData = Icons.card_giftcard;
        iconColor = Colors.green;
        break;
      case 'system':
      default:
        iconData = Icons.notifications;
        iconColor = AppColors.primary;
    }

    return Icon(
      iconData,
      color: iconColor,
      size: 24.sp,
    );
  }

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return '';

    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'time_ago.now'.tr();
    } else if (difference.inMinutes < 60) {
      return 'time_ago.minutes'.tr(
        namedArgs: {'count': '${difference.inMinutes}'},
      );
    } else if (difference.inHours < 24) {
      return 'time_ago.hours'.tr(namedArgs: {'count': '${difference.inHours}'});
    } else if (difference.inDays < 7) {
      return 'time_ago.days'.tr(namedArgs: {'count': '${difference.inDays}'});
    } else {
      return DateFormat('yyyy/MM/dd').format(dateTime);
    }
  }
}
