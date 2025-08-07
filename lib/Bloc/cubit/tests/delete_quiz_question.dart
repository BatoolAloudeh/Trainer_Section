// lib/bloc/cubit/tests/delete_quiz_question_cubit.dart

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import '../../../constant/endPoint/endPoints.dart';
import '../../../network/remote/dioHelper.dart';
import '../../states/tests/operation.dart';

class DeleteQuizQuestionCubit extends Cubit<QuizOperationState> {
  DeleteQuizQuestionCubit() : super(QuizOperationInitial());

  Future<void> deleteQuestion({
    required String token,
    required int questionId,
  }) async {
    emit(QuizOperationLoading());
    try {
      final resp = await DioHelper.postData(
        url: '$DELETEQUESTION/$questionId',
        headers: {
          'Authorization': 'Bearer $token',
        }, data: {},
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
