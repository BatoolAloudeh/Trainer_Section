// lib/Bloc/cubit/tests/list_quizzes_cubit.dart

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import '../../../constant/endPoint/endPoints.dart';
import '../../../models/tests/GetQuizzesBySectionId.dart';
import '../../../network/remote/dioHelper.dart';
import '../../states/tests/GetQuizzesBySectionId.dart';

class ListQuizzesCubit extends Cubit<ListQuizzesState> {
  ListQuizzesCubit() : super(ListQuizzesInitial());


  Future<void> fetchQuizzesBySection({
    required String token,
    required int sectionId,
    int page = 1,
  }) async {
    emit(ListQuizzesLoading());
    try {
      final response = await DioHelper.getData(
        url: '$GETQUIZZES/$sectionId',
        query: { 'page': page.toString() },
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      final map = response.data as Map<String, dynamic>;
      final quizzesResponse = QuizzesBySectionResponse.fromJson(map);
      emit(ListQuizzesLoaded(quizzesResponse));
    } on DioError catch (e) {
      final msg = (e.response?.data as Map<String, dynamic>?)?['message']
      as String? ??
          e.message;
      emit(ListQuizzesError(msg!));
    } catch (e) {
      emit(ListQuizzesError(e.toString()));
    }
  }
}
