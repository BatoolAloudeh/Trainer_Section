import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';

import '../../../models/Auth/forgetPassword.dart';
import '../../../network/remote/dioHelper.dart';
import '../../../constant/endPoint/endPoints.dart';
import '../../states/Auth/forgetPassword.dart'; // ضع فيه الثابت FORGOT_PASSWORD


class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit() : super(ForgotPasswordInitial());

  Future<void> sendCode({required String email}) async {
    emit(ForgotPasswordLoading());
    try {
      final res = await DioHelper.postData(
        url: FORGOT_PASSWORD, // مثال: '/auth/trainer/forgotPassword'
        data: {"email": email},
        headers: const {}, // interceptor سيضيف Authorization إذا موجود
      );

      final data = ForgotPasswordResponse.fromJson(res.data);
      emit(ForgotPasswordSuccess(data));
    } on DioError catch (e) {
      final msg = e.response?.data is Map
          ? ((e.response!.data['message'] ??
          e.response!.data['mes'] ??
          'Request failed') as String)
          : (e.message ?? 'Request failed');
      emit(ForgotPasswordFailure(msg));
    } catch (e) {
      emit(ForgotPasswordFailure(e.toString()));
    }
  }
}
