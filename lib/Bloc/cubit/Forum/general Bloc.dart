// // lib/bloc/forum/forum_cubit.dart
// import 'package:bloc/bloc.dart';
// import 'package:dio/dio.dart';
// import '../../../constant/endPoint/endPoints.dart';
// import '../../../models/Forum/Pagination.dart';
// import '../../../models/Forum/question.dart';
// import '../../states/Forum/general state.dart';
//
// class ForumCubit extends Cubit<ForumState> {
//   ForumCubit(): super(ForumInitial());
//   final _dio = Dio();
//
//   Future<void> fetchSectionQuestions({
//     required String token,
//     required int    sectionId,
//   }) async {
//     emit(ForumLoading());
//     try {
//       final url = GET_SECTION_QUESTIONS
//           .replaceFirst('{section_id}', '$sectionId');
//       final res = await _dio.get(url,
//           options: Options(headers: {'Authorization':'Bearer $token'}));
//       final page = PaginatedQuestions.fromJson(res.data as Map<String, dynamic>);
//       emit(SectionQuestionsLoaded(page));
//     } on DioError catch(e) {
//       emit(ForumError(e.response?.data['message'] ?? e.message));
//     }
//   }
//
//   Future<void> createQuestion({
//     required String token,
//     required String content,
//     required int    sectionId,
//   }) async {
//     emit(ForumLoading());
//     try {
//       final res = await _dio.post(CREATE_QUESTION,
//           data: {
//             'content':            content,
//             'course_section_id': sectionId,
//           },
//           options: Options(headers: {'Authorization':'Bearer $token'}));
//       final q = QuestionModel.fromJson(res.data as Map<String, dynamic>);
//       emit(QuestionCreated(q));
//     } on DioError catch(e) {
//       emit(ForumError(e.response?.data['message'] ?? e.message));
//     }
//   }
//
//   Future<void> updateQuestion({
//     required String token,
//     required int    questionId,
//     required String content,
//   }) async {
//     emit(ForumLoading());
//     try {
//       final url = UPDATE_QUESTION
//           .replaceFirst('{question_id}', '$questionId');
//       final res = await _dio.put(url,
//           data: {'content': content},
//           options: Options(headers: {'Authorization':'Bearer $token'}));
//       final q = QuestionModel.fromJson(res.data as Map<String, dynamic>);
//       emit(QuestionUpdated(q));
//     } on DioError catch(e) {
//       emit(ForumError(e.response?.data['message'] ?? e.message));
//     }
//   }
//
//   Future<void> deleteQuestion({
//     required String token,
//     required int    questionId,
//   }) async {
//     emit(ForumLoading());
//     try {
//       final url = DELETE_QUESTION
//           .replaceFirst('{question_id}', '$questionId');
//       await _dio.delete(url,
//           options: Options(headers: {'Authorization':'Bearer $token'}));
//       emit(QuestionDeleted());
//     } on DioError catch(e) {
//       emit(ForumError(e.response?.data['message'] ?? e.message));
//     }
//   }
//
//   Future<void> likeQuestion({
//     required String token,
//     required int    questionId,
//   }) async {
//     emit(ForumLoading());
//     try {
//       final url = LIKE_QUESTION
//           .replaceFirst('{question_id}', '$questionId');
//       await _dio.post(url,
//           options: Options(headers: {'Authorization':'Bearer $token'}));
//       emit(QuestionLiked());
//     } on DioError catch(e) {
//       emit(ForumError(e.response?.data['message'] ?? e.message));
//     }
//   }
//
//   Future<void> unlikeQuestion({
//     required String token,
//     required int    questionId,
//   }) async {
//     emit(ForumLoading());
//     try {
//       final url =UNLIKE_QUESTION
//           .replaceFirst('{question_id}', '$questionId');
//       await _dio.delete(url,
//           options: Options(headers: {'Authorization':'Bearer $token'}));
//       emit(QuestionUnliked());
//     } on DioError catch(e) {
//       emit(ForumError(e.response?.data['message'] ?? e.message));
//     }
//   }
// }
//
//
//









import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';

import '../../../constant/endPoint/endPoints.dart';
import '../../../models/Forum/Pagination.dart';
import '../../../models/Forum/question.dart';
import '../../../network/remote/dioHelper.dart';
import '../../states/Forum/general state.dart';

class ForumCubit extends Cubit<ForumState> {
  ForumCubit() : super(ForumInitial());

  Future<void> fetchSectionQuestions({
    required int sectionId,
  }) async {
    emit(ForumLoading());
    try {
      final url = GET_SECTION_QUESTIONS.replaceFirst('{section_id}', '$sectionId');
      final res = await DioHelper.getData(url: url);
      final page = PaginatedQuestions.fromJson(res.data);
      emit(SectionQuestionsLoaded(page));
    } on DioError catch (e) {
      emit(ForumError(e.response?.data['message'] ?? e.message));
    }
  }

  Future<void> createQuestion({
    required String content,
    required int sectionId,
  }) async {
    emit(ForumLoading());
    try {
      final res = await DioHelper.postData(
        url: CREATE_QUESTION,
        data: {
          'content': content,
          'course_section_id': sectionId,
        },
        headers: {},
      );
      final q = QuestionModel.fromJson(res.data);
      emit(QuestionCreated(q));
    } on DioError catch (e) {
      emit(ForumError(e.response?.data['message'] ?? e.message));
    }
  }

  Future<void> updateQuestion({
    required int questionId,
    required String content,
  }) async {
    emit(ForumLoading());
    try {
      final url = UPDATE_QUESTION.replaceFirst('{question_id}', '$questionId');
      final res = await DioHelper.putData(
        url: url,
        data: {'content': content},
      );
      final q = QuestionModel.fromJson(res.data);
      emit(QuestionUpdated(q));
    } on DioError catch (e) {
      emit(ForumError(e.response?.data['message'] ?? e.message));
    }
  }

  Future<void> deleteQuestion({required int questionId}) async {
    emit(ForumLoading());
    try {
      final url = DELETE_QUESTION.replaceFirst('{question_id}', '$questionId');
      await DioHelper.deleteData(url: url);
      emit(QuestionDeleted());
    } on DioError catch (e) {
      emit(ForumError(e.response?.data['message'] ?? e.message));
    }
  }

  Future<void> likeQuestion({required int questionId}) async {
    emit(ForumLoading());
    try {
      final url = LIKE_QUESTION.replaceFirst('{question_id}', '$questionId');
      await DioHelper.postData(url: url, data: {}, headers: {});
      emit(QuestionLiked());
    } on DioError catch (e) {
      emit(ForumError(e.response?.data['message'] ?? e.message));
    }
  }

  Future<void> unlikeQuestion({required int questionId}) async {
    emit(ForumLoading());
    try {
      final url = UNLIKE_QUESTION.replaceFirst('{question_id}', '$questionId');
      await DioHelper.deleteData(url: url);
      emit(QuestionUnliked());
    } on DioError catch (e) {
      emit(ForumError(e.response?.data['message'] ?? e.message));
    }
  }
}
