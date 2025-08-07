// lib/bloc/cubit/tests/update_quiz_question_cubit.dart

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import '../../../constant/endPoint/endPoints.dart';
import '../../../network/remote/dioHelper.dart';
import '../../../models/tests/quiz_question_update.dart';
import '../../states/tests/operation.dart';

class UpdateQuizQuestionCubit extends Cubit<QuizOperationState> {
  UpdateQuizQuestionCubit() : super(QuizOperationInitial());

  Future<void> updateQuestion({
    required String token,
    required int questionId,
    required QuizQuestionUpdate data,
  }) async {
    emit(QuizOperationLoading());
    try {
      final resp = await DioHelper.postData(
        url: '$UPDATEQUESTION/$questionId',
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
