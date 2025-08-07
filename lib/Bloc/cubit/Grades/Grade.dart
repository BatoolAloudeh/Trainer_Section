// import 'package:bloc/bloc.dart';
// import 'package:dio/dio.dart';
// import 'package:trainer_section/Bloc/states/Grades/Grade.dart';
// import '../../../constant/endPoint/endPoints.dart';
// import '../../../models/Grades/Grades.dart';
// import '../../../models/Grades/PaginatedGrades.dart';
//
//
//
// class GradeCubit extends Cubit<GradeState> {
//   GradeCubit(): super(GradeInitial());
//   final _dio = Dio();
//
//   Future<void> fetchGrades({
//     required String token,
//     required int examId,
//   }) async {
//     emit(GradeLoading());
//     try {
//       final url = GET_GRADES_BY_EXAM.replaceFirst('{exam_id}', '$examId');
//       final res = await _dio.get(url,
//         options: Options(headers: {'Authorization':'Bearer $token'}),
//       );
//       // res.data['grades'] هي الباجينيشن
//       final page = PaginatedGrades.fromJson(res.data['grades'] as Map<String, dynamic>);
//       emit(GradesLoaded(page));
//     } on DioError catch (e) {
//       emit(GradeError(e.response?.data['message'] ?? e.message));
//     }
//   }
//
//   Future<void> createGrade({
//     required String token,
//     required int studentId,
//     required int examId,
//     required double grade,
//   }) async {
//     emit(GradeLoading());
//     try {
//       await _dio.post(CREATE_GRADE,
//         data: {
//           'student_id': studentId,
//           'exam_id':    examId,
//           'grade':      grade.toStringAsFixed(2),
//         },
//         options: Options(headers: {'Authorization':'Bearer $token'}),
//       );
//       emit(GradeCreated());
//     } on DioError catch (e) {
//       emit(GradeError(e.response?.data['message'] ?? e.message));
//     }
//   }
//
//   Future<void> updateGrade({
//     required String token,
//     required int gradeId,
//     required double grade,
//   }) async {
//     emit(GradeLoading());
//     try {
//       final url = UPDATE_GRADE.replaceFirst('{grade_id}', '$gradeId');
//       await _dio.put(url,
//         data: {'grade': grade.toStringAsFixed(2)},
//         options: Options(headers: {'Authorization':'Bearer $token'}),
//       );
//       emit(GradeUpdated());
//     } on DioError catch (e) {
//       emit(GradeError(e.response?.data['message'] ?? e.message));
//     }
//   }
//
//   Future<void> deleteGrade({
//     required String token,
//     required int gradeId,
//   }) async {
//     emit(GradeLoading());
//     try {
//       final url = DELETE_GRADE.replaceFirst('{grade_id}', '$gradeId');
//       await _dio.delete(url,
//         options: Options(headers: {'Authorization':'Bearer $token'}),
//       );
//       emit(GradeDeleted());
//     } on DioError catch (e) {
//       emit(GradeError(e.response?.data['message'] ?? e.message));
//     }
//   }
// }






import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:trainer_section/Bloc/states/Grades/Grade.dart';

import '../../../constant/endPoint/endPoints.dart';
import '../../../models/Grades/Grades.dart';
import '../../../models/Grades/PaginatedGrades.dart';
import '../../../network/remote/dioHelper.dart';

class GradeCubit extends Cubit<GradeState> {
  GradeCubit() : super(GradeInitial());

  Future<void> fetchGrades({
    required int examId,
  }) async {
    emit(GradeLoading());
    try {
      final url = GET_GRADES_BY_EXAM.replaceFirst('{exam_id}', '$examId');
      final res = await DioHelper.getData(url: url);
      final page = PaginatedGrades.fromJson(res.data['grades']);
      emit(GradesLoaded(page));
    } on DioError catch (e) {
      emit(GradeError(e.response?.data['message'] ?? e.message));
    }
  }

  Future<void> createGrade({
    required int studentId,
    required int examId,
    required double grade,
  }) async {
    emit(GradeLoading());
    try {
      await DioHelper.postData(
        url: CREATE_GRADE,
        data: {
          'student_id': studentId,
          'exam_id': examId,
          'grade': grade.toStringAsFixed(2),
        },
        headers: {}, // DioHelper يضيف التوكن تلقائيًا
      );
      emit(GradeCreated());
    } on DioError catch (e) {
      emit(GradeError(e.response?.data['message'] ?? e.message));
    }
  }

  Future<void> updateGrade({
    required int gradeId,
    required double grade,
  }) async {
    emit(GradeLoading());
    try {
      final url = UPDATE_GRADE.replaceFirst('{grade_id}', '$gradeId');
      await DioHelper.putData(
        url: url,
        data: {'grade': grade.toStringAsFixed(2)},
      );
      emit(GradeUpdated());
    } on DioError catch (e) {
      emit(GradeError(e.response?.data['message'] ?? e.message));
    }
  }

  Future<void> deleteGrade({
    required int gradeId,
  }) async {
    emit(GradeLoading());
    try {
      final url = DELETE_GRADE.replaceFirst('{grade_id}', '$gradeId');
      await DioHelper.deleteData(url: url);
      emit(GradeDeleted());
    } on DioError catch (e) {
      emit(GradeError(e.response?.data['message'] ?? e.message));
    }
  }
}
