import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';

import '../../../constant/endPoint/endPoints.dart';
import '../../../models/tests/create test.dart';
import '../../../network/remote/dioHelper.dart';
import '../../states/tests/create test.dart';

class QuizCubit extends Cubit<QuizState> {
  QuizCubit() : super(QuizInitial());


  Future<void> createQuiz({
    required String token,
    required Quiz quiz,
  }) async {
    emit(QuizLoading());
    print('🔶 QuizCubit.createQuiz: token=${token.substring(0,20)}..., payload=${quiz.toJson()}');
    try {
      final response = await DioHelper.postData(
        url: CREATEQUIZ,
        data: quiz.toJson(),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      print('🔶 QuizCubit.success response: ${response.data}');
      final qr = QuizResponse.fromJson(response.data as Map<String, dynamic>);
      emit(QuizSuccess(qr));
    } on DioError catch (e) {
      final msg = (e.response?.data as Map<String, dynamic>?)?['message'] as String? ?? e.message;
      print('🔶 QuizCubit.error: $msg');
      emit(QuizFailure(msg!));
    } catch (e) {
      print('🔶 QuizCubit.exception: $e');
      emit(QuizFailure(e.toString()));
    }
  }
}
