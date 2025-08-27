import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';

import '../../../constant/constantKey/key.dart';
import '../../../models/Auth/logout.dart';
import '../../../network/local/cacheHelper.dart';
import '../../../network/remote/dioHelper.dart';
import '../../states/Auth/logout.dart';



class LogoutCubit extends Cubit<LogoutState> {
  LogoutCubit() : super(LogoutInitial());

  /// ينفّذ POST /auth/trainer/logout
  Future<void> logout() async {
    emit(LogoutLoading());
    try {
      final res = await DioHelper.postData(
        url: '/auth/trainer/logout',   // baseUrl مضبوط داخل DioHelper.init()
        data: const {},                // لا يوجد body
        headers: const {},             // وسيط مطلوب في دالتك
      );

      final model = LogoutResponse.fromJson(res.data);

      // (اختياري) تنظيف التوكن من التخزين بعد نجاح الخروج
      try {
        await CacheHelper.deleteData(key: TOKENKEY);
      } catch (_) {}

      emit(LogoutSuccess(model));
    } on DioException catch (e) {
      final msg = e.response?.data is Map<String, dynamic>
          ? (e.response!.data['message']?.toString() ?? 'Request failed')
          : (e.message ?? 'Request failed');
      emit(LogoutFailure(msg));
    } catch (e) {
      emit(LogoutFailure(e.toString()));
    }
  }
}
