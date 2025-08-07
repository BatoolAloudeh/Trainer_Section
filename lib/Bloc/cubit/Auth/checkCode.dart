
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';

import '../../../constant/endPoint/endPoints.dart';
import '../../../models/Auth/checkCode.dart';
import '../../../network/remote/dioHelper.dart';
import '../../states/Auth/checkCode.dart';


class CheckCodeCubit extends Cubit<CheckCodeState> {
  CheckCodeCubit() : super(CheckCodeInitial());


  Future<void> verifyEmailToken({required String token}) async {
    emit(CheckCodeLoading());
    try {
      final response = await DioHelper.postData(
        url: CHECKCODE,
        data: {'token': token},
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200 && response.data != null) {
        final model = CheckCodeModel.fromJson(response.data);
        emit(CheckCodeSuccess(model));
      } else {
        emit(const CheckCodeError('There is an error..it might be in the code..check..then try againً'));
      }
    } on DioError catch (e) {

      final msg = e.response?.data['Message'] ?? e.message;
      emit(CheckCodeError(msg.toString()));
    } catch (e) {
      emit(CheckCodeError(e.toString()));
    }
  }
}
