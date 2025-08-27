import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import '../../../models/Auth/resetPassword.dart';
import '../../../network/remote/dioHelper.dart';
import '../../../constant/endPoint/endPoints.dart'; // ضع فيه الثابت RESET_PASSWORD
import '../../states/Auth/resetPassword.dart';


class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit() : super(ResetPasswordInitial());

  Future<void> resetPassword({
    required String token,
    required String password,
    required String passwordConfirmation,
  }) async {
    emit(ResetPasswordLoading());
    try {
      final res = await DioHelper.postData(
        url: RESET_PASSWORD, // مثال: '/auth/trainer/passwordReset'
        data: {
          "token": token,
          "password": password,
          "password_confirmation": passwordConfirmation,
        },
        headers: const {}, // interceptor سيضيف Authorization إذا موجود
      );

      final data = ResetPasswordResponse.fromJson(res.data);
      emit(ResetPasswordSuccess(data));
    } on DioError catch (e) {
      final msg = e.response?.data is Map
          ? ((e.response!.data['message'] ?? 'Request failed') as String)
          : (e.message ?? 'Request failed');
      emit(ResetPasswordFailure(msg));
    } catch (e) {
      emit(ResetPasswordFailure(e.toString()));
    }
  }
}
