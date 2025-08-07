// lib/bloc/cubit/tests/update_quiz_title_cubit.dart

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import '../../../constant/endPoint/endPoints.dart';
import '../../../network/remote/dioHelper.dart';

import '../../../models/tests/quiz_title_update.dart';
import '../../states/tests/operation.dart';

class UpdateQuizTitleCubit extends Cubit<QuizOperationState> {
  UpdateQuizTitleCubit() : super(QuizOperationInitial());

  Future<void> updateTitle({
    required String token,
    required int quizId,
    required QuizTitleUpdate data,
  }) async {
    emit(QuizOperationLoading());
    try {
      final resp = await DioHelper.postData(
        url: '$UPDATETITLE/$quizId',
        data: data.toJson(),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      final msg = (resp.data as Map<String, dynamic>)['message'] as String;
      emit(QuizOperationSuccess(msg));
    } on DioError catch (e) {
      final err = (e.response?.data as Map<String, dynamic>?)?['message']
      as String? ?? e.message;
      emit(QuizOperationFailure(err!));
    }
  }
}
