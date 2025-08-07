import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import '../../../constant/constantKey/key.dart';
import '../../../constant/endPoint/endPoints.dart';
import '../../../models/Calendar/calendar.dart';
import '../../../network/local/cacheHelper.dart';
import '../../../network/remote/dioHelper.dart';
import '../../states/Calendar/calendar.dart';


class ScheduleCubit extends Cubit<ScheduleState> {
  ScheduleCubit() : super(ScheduleInitial());


  Future<void> fetchByDay({required String dayName, required String token}) async {
    emit(ScheduleLoading());

    try {

      final path = '${GET_SCHEDULE_BY_DAY}/$dayName';
      final response = await DioHelper.getData(url: path);


      if (response.statusCode == 200) {
        final json = response.data as Map<String, dynamic>;
        final respModel = ScheduleEventResponse.fromJson(json);
        emit(ScheduleLoaded(respModel.events));
      } else {
        emit(ScheduleError('Server returned ${response.statusCode}'));
      }
    } on DioError catch (e) {
      final msg = e.response?.data['message'] ??
          e.message ??
          'Unknown Dio error';
      emit(ScheduleError(msg));
    } catch (e) {
      emit(ScheduleError(e.toString()));
    }
  }
}
