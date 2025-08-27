// Bloc/cubit/notifications/notifications_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';

import '../../../constant/endPoint/endPoints.dart';
import '../../../models/notification/notification.dart';
import '../../../network/remote/dioHelper.dart';
import '../../states/notification/notification.dart';


class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(NotificationsInitial());

  Future<void> fetchNotifications() async {
    emit(NotificationsLoading());
    try {
      final Response res = await DioHelper.getData(url: GET_NOTIFICATIONS);
      final data = res.data as Map<String, dynamic>;
      final parsed = NotificationsResponse.fromJson(data);
      emit(NotificationsLoaded(parsed.notifications));
    } catch (e) {
      emit(NotificationsFailure('Failed to load notifications'));
    }
  }
}
