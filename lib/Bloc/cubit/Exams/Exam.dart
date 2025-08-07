// import 'package:bloc/bloc.dart';
// import 'package:dio/dio.dart';
// import 'package:trainer_section/Bloc/states/Exams/Exam.dart';
// import '../../../constant/endPoint/endPoints.dart';
// import '../../../models/Exams/Exam.dart';
// import '../../../models/Exams/PaginatedExams.dart';
//
//
// class ExamCubit extends Cubit<ExamState> {
//   ExamCubit(): super(ExamInitial());
//   final _dio = Dio();
//
//   Future<void> fetchExams({
//     required String token,
//     required int sectionId,
//   }) async {
//     emit(ExamLoading());
//     try {
//       final url = GET_EXAMS_BY_SECTION.replaceFirst('{section_id}', '$sectionId');
//       final res = await _dio.get(url,
//         options: Options(headers: {'Authorization':'Bearer $token'}),
//       );
//       final page = PaginatedExams.fromJson((res.data as Map<String,dynamic>)['exams'] as Map<String,dynamic>);
//       emit(ExamsLoaded(page));
//     } on DioError catch(e) {
//       emit(ExamError(e.response?.data['message'] ?? e.message));
//     }
//   }
//
//   Future<void> createExam({
//     required String token,
//     required String name,
//     required DateTime examDate,
//     required int courseSectionId,
//   }) async {
//     emit(ExamLoading());
//     try {
//       final res = await _dio.post(
//         CREATE_EXAM,
//         data: {
//           'name': name,
//           'exam_date': examDate.toIso8601String(),
//           'course_section_id': courseSectionId,
//         },
//         options: Options(headers: {'Authorization':'Bearer $token'}),
//       );
//       final exam = ExamModel.fromJson((res.data as Map<String,dynamic>)['exam'] as Map<String,dynamic>);
//       emit(ExamCreated(exam));
//     } on DioError catch(e) {
//       emit(ExamError(e.response?.data['message'] ?? e.message));
//     }
//   }
//
//   Future<void> updateExam({
//     required String token,
//     required int examId,
//     required String name,
//     required DateTime examDate,
//   }) async {
//     emit(ExamLoading());
//     try {
//       final url = UPDATE_EXAM.replaceFirst('{exam_id}', '$examId');
//       final res = await _dio.put(
//         url,
//         data: {
//           'name': name,
//           'exam_date': examDate.toIso8601String(),
//         },
//         options: Options(headers: {'Authorization':'Bearer $token'}),
//       );
//       final exam = ExamModel.fromJson((res.data as Map<String,dynamic>)['exam'] as Map<String,dynamic>);
//       emit(ExamUpdated(exam));
//     } on DioError catch(e) {
//       emit(ExamError(e.response?.data['message'] ?? e.message));
//     }
//   }
//
//   Future<void> deleteExam({
//     required String token,
//     required int examId,
//   }) async {
//     emit(ExamLoading());
//     try {
//       final url = DELETE_EXAM.replaceFirst('{exam_id}', '$examId');
//       await _dio.delete(url,
//         options: Options(headers: {'Authorization':'Bearer $token'}),
//       );
//       emit(ExamDeleted());
//     } on DioError catch(e) {
//       emit(ExamError(e.response?.data['message'] ?? e.message));
//     }
//   }
// }


import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:trainer_section/Bloc/states/Exams/Exam.dart';

import '../../../constant/endPoint/endPoints.dart';
import '../../../models/Exams/Exam.dart';
import '../../../models/Exams/PaginatedExams.dart';
import '../../../network/remote/dioHelper.dart';

class ExamCubit extends Cubit<ExamState> {
  ExamCubit() : super(ExamInitial());

  Future<void> fetchExams({
    required int sectionId,
  }) async {
    emit(ExamLoading());
    try {
      final url = GET_EXAMS_BY_SECTION.replaceFirst('{section_id}', '$sectionId');
      final res = await DioHelper.getData(url: url);
      final page = PaginatedExams.fromJson((res.data as Map<String, dynamic>)['exams']);
      emit(ExamsLoaded(page));
    } on DioError catch (e) {
      emit(ExamError(e.response?.data['message'] ?? e.message));
    }
  }

  Future<void> createExam({
    required String name,
    required DateTime examDate,
    required int courseSectionId,
  }) async {
    emit(ExamLoading());
    try {
      final res = await DioHelper.postData(
        url: CREATE_EXAM,
        data: {
          'name': name,
          'exam_date': examDate.toIso8601String(),
          'course_section_id': courseSectionId,
        },
        headers: {},
      );
      final exam = ExamModel.fromJson((res.data as Map<String, dynamic>)['exam']);
      emit(ExamCreated(exam));
    } on DioError catch (e) {
      emit(ExamError(e.response?.data['message'] ?? e.message));
    }
  }

  Future<void> updateExam({
    required int examId,
    required String name,
    required DateTime examDate,
  }) async {
    emit(ExamLoading());
    try {
      final url = UPDATE_EXAM.replaceFirst('{exam_id}', '$examId');
      final res = await DioHelper.putData(
        url: url,
        data: {
          'name': name,
          'exam_date': examDate.toIso8601String(),
        },
      );
      final exam = ExamModel.fromJson((res.data as Map<String, dynamic>)['exam']);
      emit(ExamUpdated(exam));
    } on DioError catch (e) {
      emit(ExamError(e.response?.data['message'] ?? e.message));
    }
  }

  Future<void> deleteExam({
    required int examId,
  }) async {
    emit(ExamLoading());
    try {
      final url = DELETE_EXAM.replaceFirst('{exam_id}', '$examId');
      await DioHelper.deleteData(url: url);
      emit(ExamDeleted());
    } on DioError catch (e) {
      emit(ExamError(e.response?.data['message'] ?? e.message));
    }
  }
}
