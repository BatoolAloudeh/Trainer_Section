
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';

import '../../../constant/constantKey/key.dart';
import '../../../constant/endPoint/endPoints.dart';
import '../../../models/Auth/Login.dart';
import '../../../network/local/cacheHelper.dart';
import '../../../network/remote/dioHelper.dart';
import '../../states/Auth/Login.dart';


class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());
  Future<void> login({
    required String email,
    required String password,
    required String fcmToken,
  }) async {
    emit(LoginLoading());
    try {
      final response = await DioHelper.postData(
        url: LOGIN,
        data: {
          'email': email,
          'password': password,
          'fcm_token': fcmToken,
        },
        headers: {},
      );


      final data = response.data as Map<String, dynamic>;


      if (data.containsKey('AccessToken')) {
        final model = LoginModel.fromJson(data);
        await CacheHelper.saveData(
          key: TOKENKEY,
          value: model.accessToken!.accessToken,
        );
        emit(LoginSuccess(model.accessToken!));
        return;
      }


      emit(LoginFailure(
        'There is an error in either the email or the password. Please check and try again.',
      ));
    } on DioError catch (err) {
      final d = err.response?.data;
      if (d is Map<String, dynamic>) {

        if (d.containsKey('Message') &&
            (d['Message'] as String).toLowerCase().trim() ==
                'your account not verified') {
          emit(LoginNotVerified());
          return;
        }

        if (d.containsKey('email')) {
          final e = d['email'];
          final msg = e is List && e.isNotEmpty ? e.first.toString() : e.toString();
          emit(LoginFailure(msg));
          return;
        }
      }

      emit(LoginFailure(
        'There is an error in either the email or the password. Please check and try again.',
      ));
    } catch (_) {
      emit(LoginFailure(
        'There is an error in either the email or the password. Please check and try again.',
      ));
    }
  }


}
