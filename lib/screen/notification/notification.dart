// screen/Notifications/notifications_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


import '../../Bloc/cubit/notification/notification.dart';
import '../../Bloc/states/notification/notification.dart';
import '../../constant/ui/Colors/colors.dart';
import '../../constant/ui/General constant/ConstantUi.dart';
import '../../localization/app_localizations.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  String _formatTime(DateTime? dt) {
    if (dt == null) return '';
    // بس عرض تاريخ/وقت مختصر
    return '${dt.toLocal()}'.split('.')[0].replaceFirst('T', ' ');
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NotificationsCubit()..fetchNotifications(),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Row(
          children: [
            const AppSidebar(selectedItem: SidebarItem.notifications),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)?.translate("notifications") ?? "Notifications"
                      ,
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkBlue,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Expanded(
                      child: BlocBuilder<NotificationsCubit, NotificationsState>(
                        builder: (context, state) {
                          if (state is NotificationsLoading) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (state is NotificationsFailure) {
                            return Center(
                              child: Text(state.error, style: const TextStyle(color: Colors.red)),
                            );
                          }
                          if (state is NotificationsLoaded) {
                            final items = state.items;
                            if (items.isEmpty) {
                              return Center(
                                child: Text(
                                  'No notifications yet',
                                  style: TextStyle(color: AppColors.t3, fontSize: 16.sp),
                                ),
                              );
                            }
                            return ListView.separated(
                              itemCount: items.length,
                              separatorBuilder: (_, __) => SizedBox(height: 10.h),
                              itemBuilder: (_, i) {
                                final n = items[i];
                                final unread = n.isRead == 0;
                                return Container(
                                  padding: EdgeInsets.all(14.w),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(12.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 6.r,
                                        offset: Offset(0, 3.h),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // مؤشر غير مقروء
                                      Container(
                                        width: 10.r,
                                        height: 10.r,
                                        margin: EdgeInsets.only(top: 6.h, right: 10.w),
                                        decoration: BoxDecoration(
                                          color: unread ? AppColors.orange : Colors.transparent,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    n.title,
                                                    style: TextStyle(
                                                      fontSize: 16.sp,
                                                      fontWeight: FontWeight.w700,
                                                      color: AppColors.darkBlue,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  _formatTime(n.createdAt),
                                                  style: TextStyle(fontSize: 12.sp, color: AppColors.t2),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 6.h),
                                            Text(
                                              n.body,
                                              style: TextStyle(fontSize: 14.sp, color: AppColors.t4),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
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
            ),
          ],
        ),
      ),
    );
  }
}
