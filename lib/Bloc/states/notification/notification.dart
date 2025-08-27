

import '../../../models/notification/notification.dart';

abstract class NotificationsState {}

class NotificationsInitial extends NotificationsState {}

class NotificationsLoading extends NotificationsState {}

class NotificationsLoaded extends NotificationsState {
  final List<NotificationItem> items;
  NotificationsLoaded(this.items);
}

class NotificationsFailure extends NotificationsState {
  final String error;
  NotificationsFailure(this.error);
}
