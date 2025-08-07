// import 'package:bloc/bloc.dart';
// import 'package:dio/dio.dart';
//
// import '../../../models/Attendence/attendence.dart';
// import '../../states/Attendence/attendence.dart';
//
// import '../../../constant/constantKey/key.dart';
//
//
// class AttendanceCubit extends Cubit<AttendanceState> {
//   AttendanceCubit(): super(AttendanceInitial());
//   final _dio = Dio();
//
//   Future<void> fetchAttendance({
//     required String token,
//     required int sessionId,
//   }) async {
//     emit(AttendanceLoading());
//     try {
//       final url = '$BASE_URL_API/session-attendance/sessions/$sessionId/attendance';
//       final res = await _dio.get(url,
//         options: Options(headers: {'Authorization':'Bearer $token'}),
//       );
//       final raw = res.data['attendance'] as List<dynamic>;
//       final list = raw
//           .map((j) => AttendanceModel.fromJson(j as Map<String, dynamic>))
//           .toList();
//       emit(AttendanceLoaded(list));
//     } on DioError catch (e) {
//       emit(AttendanceError(e.response?.data['message'] ?? e.message));
//     }
//   }
//
//   Future<void> markAttendance({
//     required String token,
//     required int sessionId,
//     required int studentId,
//     required bool isPresent,
//   }) async {
//     emit(AttendanceLoading());
//     try {
//       final url = '$BASE_URL_API/session-attendance/sessions/$sessionId/attendance';
//       await _dio.post(url,
//         data: {
//           'student_id': studentId.toString(),
//           'is_present': isPresent,
//         },
//         options: Options(headers: {'Authorization':'Bearer $token'}),
//       );
//       emit(AttendanceMarked());
//     } on DioError catch (e) {
//       emit(AttendanceError(e.response?.data['message'] ?? e.message));
//     }
//   }
//
//   Future<void> updateAttendance({
//     required String token,
//     required int attendanceId,
//     required bool isPresent,
//   }) async {
//     emit(AttendanceLoading());
//     try {
//       final url = '$BASE_URL_API/session-attendance/attendance/$attendanceId';
//       await _dio.put(url,
//         data: {'is_present': isPresent},
//         options: Options(headers: {'Authorization':'Bearer $token'}),
//       );
//       emit(AttendanceUpdated());
//     } on DioError catch (e) {
//       emit(AttendanceError(e.response?.data['message'] ?? e.message));
//     }
//   }
//
//   Future<void> deleteAttendance({
//     required String token,
//     required int attendanceId,
//   }) async {
//     emit(AttendanceLoading());
//     try {
//       final url = '$BASE_URL_API/session-attendance/attendance/$attendanceId';
//       await _dio.delete(url,
//         options: Options(headers: {'Authorization':'Bearer $token'}),
//       );
//       emit(AttendanceDeleted());
//     } on DioError catch (e) {
//       emit(AttendanceError(e.response?.data['message'] ?? e.message));
//     }
//   }
// }







import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';

import '../../../constant/endPoint/endPoints.dart';
import '../../../models/Attendence/attendence.dart';
import '../../../network/remote/dioHelper.dart';
import '../../states/Attendence/attendence.dart';


class AttendanceCubit extends Cubit<AttendanceState> {
  AttendanceCubit() : super(AttendanceInitial());

  Future<void> fetchAttendance({
    required int sessionId,
  }) async {
    emit(AttendanceLoading());
    try {
      final url = FETCHATTENDANCE.replaceFirst('{session_id}', sessionId.toString());
      final res = await DioHelper.getData(url: url);
      final raw = res.data['attendance'] as List<dynamic>;
      final list = raw
          .map((j) => AttendanceModel.fromJson(j as Map<String, dynamic>))
          .toList();
      emit(AttendanceLoaded(list));
    } on DioError catch (e) {
      emit(AttendanceError(e.response?.data['message'] ?? e.message));
    }
  }

  Future<void> markAttendance({
    required int sessionId,
    required int studentId,
    required bool isPresent,
  }) async {
    emit(AttendanceLoading());
    try {
      final url = MARKATTENDANCE.replaceFirst('{session_id}', sessionId.toString());
      await DioHelper.postData(
        url: url,
        data: {
          'student_id': studentId.toString(),
          'is_present': isPresent,
        },
        headers: {},
      );
      emit(AttendanceMarked());
    } on DioError catch (e) {
      emit(AttendanceError(e.response?.data['message'] ?? e.message));
    }
  }

  Future<void> updateAttendance({
    required int attendanceId,
    required bool isPresent,
  }) async {
    emit(AttendanceLoading());
    try {
      final url = UPDATEATTENDANCE.replaceFirst('{attendanceId}', attendanceId.toString());
      await DioHelper.putData(
        url: url,
        data: {'is_present': isPresent},
      );
      emit(AttendanceUpdated());
    } on DioError catch (e) {
      emit(AttendanceError(e.response?.data['message'] ?? e.message));
    }
  }

  Future<void> deleteAttendance({
    required int attendanceId,
  }) async {
    emit(AttendanceLoading());
    try {
      final url = DELETEATTENDANCE.replaceFirst('{attendanceId}', attendanceId.toString());
      await DioHelper.dio.delete(url);
      emit(AttendanceDeleted());
    } on DioError catch (e) {
      emit(AttendanceError(e.response?.data['message'] ?? e.message));
    }
  }
}
