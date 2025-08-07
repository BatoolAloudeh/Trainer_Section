// // lib/bloc/Forum/answer_cubit.dart
//
// import 'package:bloc/bloc.dart';
// import 'package:dio/dio.dart';
//
// import '../../../constant/endPoint/endPoints.dart';
// import '../../../models/Forum/answer.dart';
// import '../../states/Forum/AnswerState.dart';
//
//
// class AnswerCubit extends Cubit<AnswerState> {
//   AnswerCubit() : super(AnswerInitial());
//   final _dio = Dio();
//
//   Future<void> fetchAnswers({
//     required String token,
//     required int questionId,
//
//   }) async {
//     emit(AnswerLoading());
//     try {
//       final url = GET_QUESTION_ANSWERS
//           .replaceFirst('{question_id}', '$questionId');
//       final res = await _dio.get(url,
//         options: Options(headers: {'Authorization': 'Bearer $token'}),
//       );
//       final list = (res.data as List<dynamic>)
//           .map((j) => AnswerModel.fromJson(j as Map<String, dynamic>))
//           .toList();
//       emit(AnswersLoaded(list));
//     } on DioError catch (e) {
//       emit(AnswerError(e.response?.data['message'] ?? e.message));
//     }
//   }
//
//   Future<void> createAnswer({
//     required String token,
//     required int questionId,
//     required String content,
//     required int courseSectionId,
//   }) async {
//     emit(AnswerLoading());
//     try {
//       await _dio.post(
//         CREATE_ANSWER,
//         data: {
//           'question_id': questionId,
//           'content': content,
//           'course_section_id': courseSectionId,
//         },
//         options: Options(headers: {'Authorization': 'Bearer $token'}),
//       );
//       emit(AnswerCreated());
//     } on DioError catch (e) {
//       emit(AnswerError(e.response?.data['message'] ?? e.message));
//     }
//   }
//
//   Future<void> updateAnswer({
//     required String token,
//     required int answerId,
//     required String content,
//   }) async {
//     emit(AnswerLoading());
//     try {
//       final url = UPDATE_ANSWER.replaceFirst('{answer_id}', '$answerId');
//       await _dio.put(
//         url,
//         data: {'content': content},
//         options: Options(headers: {'Authorization': 'Bearer $token'}),
//       );
//       emit(AnswerUpdated());
//     } on DioError catch (e) {
//       emit(AnswerError(e.response?.data['message'] ?? e.message));
//     }
//   }
//
//   Future<void> deleteAnswer({
//     required String token,
//     required int answerId,
//   }) async {
//     emit(AnswerLoading());
//     try {
//       final url = DELETE_ANSWER.replaceFirst('{answer_id}', '$answerId');
//       await _dio.delete(
//         url,
//         options: Options(headers: {'Authorization': 'Bearer $token'}),
//       );
//       emit(AnswerDeleted());
//     } on DioError catch (e) {
//       emit(AnswerError(e.response?.data['message'] ?? e.message));
//     }
//   }
//
//   Future<void> likeAnswer({
//     required String token,
//     required int answerId,
//   }) async {
//     emit(AnswerLoading());
//     try {
//       final url = LIKE_ANSWER.replaceFirst('{answer_id}', '$answerId');
//       await _dio.post(
//         url,
//         options: Options(headers: {'Authorization': 'Bearer $token'}),
//       );
//       emit(AnswerLiked());
//     } on DioError catch (e) {
//       emit(AnswerError(e.response?.data['message'] ?? e.message));
//     }
//   }
//
//   Future<void> unlikeAnswer({
//     required String token,
//     required int answerId,
//   }) async {
//     emit(AnswerLoading());
//     try {
//       final url = UNLIKE_ANSWER.replaceFirst('{answer_id}', '$answerId');
//       await _dio.delete(
//         url,
//         options: Options(headers: {'Authorization': 'Bearer $token'}),
//       );
//       emit(AnswerUnliked());
//     } on DioError catch (e) {
//       emit(AnswerError(e.response?.data['message'] ?? e.message));
//     }
//   }
//
//   Future<void> acceptAnswer({
//     required String token,
//     required int answerId,
//   }) async {
//     emit(AnswerLoading());
//     try {
//       final url = ACCEPT_ANSWER.replaceFirst('{answer_id}', '$answerId');
//       await _dio.post(
//         url,
//         options: Options(headers: {'Authorization': 'Bearer $token'}),
//       );
//       emit(AnswerAccepted());
//     } on DioError catch (e) {
//       emit(AnswerError(e.response?.data['message'] ?? e.message));
//     }
//   }
//
//   Future<void> unacceptAnswer({
//     required String token,
//     required int answerId,
//   }) async {
//     emit(AnswerLoading());
//     try {
//       final url = UNACCEPT_ANSWER.replaceFirst('{answer_id}', '$answerId');
//       await _dio.delete(
//         url,
//         options: Options(headers: {'Authorization': 'Bearer $token'}),
//       );
//       emit(AnswerUnaccepted());
//     } on DioError catch (e) {
//       emit(AnswerError(e.response?.data['message'] ?? e.message));
//     }
//   }
// }
//








import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';

import '../../../constant/endPoint/endPoints.dart';
import '../../../models/Forum/answer.dart';
import '../../../network/remote/dioHelper.dart';
import '../../states/Forum/AnswerState.dart';

class AnswerCubit extends Cubit<AnswerState> {
  AnswerCubit() : super(AnswerInitial());

  Future<void> fetchAnswers({required int questionId}) async {
    emit(AnswerLoading());
    try {
      final url = GET_QUESTION_ANSWERS.replaceFirst('{question_id}', '$questionId');
      final res = await DioHelper.getData(url: url);
      final list = (res.data as List)
          .map((j) => AnswerModel.fromJson(j as Map<String, dynamic>))
          .toList();
      emit(AnswersLoaded(list));
    } on DioError catch (e) {
      emit(AnswerError(e.response?.data['message'] ?? e.message));
    }
  }

  Future<void> createAnswer({
    required int questionId,
    required String content,
    required int courseSectionId,
  }) async {
    emit(AnswerLoading());
    try {
      await DioHelper.postData(
        url: CREATE_ANSWER,
        data: {
          'question_id': questionId,
          'content': content,
          'course_section_id': courseSectionId,
        },
        headers: {},
      );
      emit(AnswerCreated());
    } on DioError catch (e) {
      emit(AnswerError(e.response?.data['message'] ?? e.message));
    }
  }

  Future<void> updateAnswer({
    required int answerId,
    required String content,
  }) async {
    emit(AnswerLoading());
    try {
      final url = UPDATE_ANSWER.replaceFirst('{answer_id}', '$answerId');
      await DioHelper.putData(url: url, data: {'content': content});
      emit(AnswerUpdated());
    } on DioError catch (e) {
      emit(AnswerError(e.response?.data['message'] ?? e.message));
    }
  }

  Future<void> deleteAnswer({required int answerId}) async {
    emit(AnswerLoading());
    try {
      final url = DELETE_ANSWER.replaceFirst('{answer_id}', '$answerId');
      await DioHelper.deleteData(url: url);
      emit(AnswerDeleted());
    } on DioError catch (e) {
      emit(AnswerError(e.response?.data['message'] ?? e.message));
    }
  }

  Future<void> likeAnswer({required int answerId}) async {
    emit(AnswerLoading());
    try {
      final url = LIKE_ANSWER.replaceFirst('{answer_id}', '$answerId');
      await DioHelper.postData(url: url, data: {}, headers: {});
      emit(AnswerLiked());
    } on DioError catch (e) {
      emit(AnswerError(e.response?.data['message'] ?? e.message));
    }
  }

  Future<void> unlikeAnswer({required int answerId}) async {
    emit(AnswerLoading());
    try {
      final url = UNLIKE_ANSWER.replaceFirst('{answer_id}', '$answerId');
      await DioHelper.deleteData(url: url);
      emit(AnswerUnliked());
    } on DioError catch (e) {
      emit(AnswerError(e.response?.data['message'] ?? e.message));
    }
  }

  Future<void> acceptAnswer({required int answerId}) async {
    emit(AnswerLoading());
    try {
      final url = ACCEPT_ANSWER.replaceFirst('{answer_id}', '$answerId');
      await DioHelper.postData(url: url, data: {}, headers: {});
      emit(AnswerAccepted());
    } on DioError catch (e) {
      emit(AnswerError(e.response?.data['message'] ?? e.message));
    }
  }

  Future<void> unacceptAnswer({required int answerId}) async {
    emit(AnswerLoading());
    try {
      final url = UNACCEPT_ANSWER.replaceFirst('{answer_id}', '$answerId');
      await DioHelper.deleteData(url: url);
      emit(AnswerUnaccepted());
    } on DioError catch (e) {
      emit(AnswerError(e.response?.data['message'] ?? e.message));
    }
  }
}
