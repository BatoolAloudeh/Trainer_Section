// import 'package:bloc/bloc.dart';
// import 'package:dio/dio.dart';
//
// import '../../../constant/endPoint/endPoints.dart';
// import '../../../models/sessions/paginatedSessions.dart';
// import '../../states/sessions/session.dart';
//
//
// class SessionCubit extends Cubit<SessionState> {
//   SessionCubit(): super(SessionInitial());
//   final _dio = Dio();
//
//   Future<void> fetchSessions({
//     required String token,
//     required int sectionId,
//   }) async {
//     emit(SessionLoading());
//     try {
//       final url = GET_SECTION_SESSIONS
//           .replaceFirst('{section_id}', '$sectionId');
//       final res = await _dio.get(url,
//         options: Options(headers: {'Authorization':'Bearer $token'}),
//       );
//       final page = PaginatedSessions.fromJson(res.data['sessions'] as Map<String, dynamic>);
//       emit(SessionsLoaded(page));
//     } on DioError catch(e) {
//       emit(SessionError(e.response?.data['message'] ?? e.message));
//     }
//   }
//
//   Future<void> createSession({
//     required String token,
//     required String name,
//     required DateTime sessionDate,
//     required int courseSectionId,
//   }) async {
//     emit(SessionLoading());
//     try {
//       final res = await _dio.post(
//         CREATE_SESSION,
//         data: {
//           'name': name,
//           'session_date': sessionDate.toIso8601String(),
//           'course_section_id': courseSectionId,
//         },
//         options: Options(headers: {'Authorization':'Bearer $token'}),
//       );
//       emit(SessionCreated());
//     } on DioError catch(e) {
//       emit(SessionError(e.response?.data['message'] ?? e.message));
//     }
//   }
//
//   Future<void> updateSession({
//     required String token,
//     required int sessionId,
//     required String name,
//     required DateTime sessionDate,
//   }) async {
//     emit(SessionLoading());
//     try {
//       final url = UPDATE_SESSION.replaceFirst('{session_id}', '$sessionId');
//       final res = await _dio.put(
//         url,
//         data: {
//           'name': name,
//           'session_date': sessionDate.toIso8601String(),
//         },
//         options: Options(headers: {'Authorization':'Bearer $token'}),
//       );
//       emit(SessionUpdated());
//     } on DioError catch(e) {
//       emit(SessionError(e.response?.data['message'] ?? e.message));
//     }
//   }
//
//   Future<void> deleteSession({
//     required String token,
//     required int sessionId,
//   }) async {
//     emit(SessionLoading());
//     try {
//       final url = DELETE_SESSION.replaceFirst('{session_id}', '$sessionId');
//       await _dio.delete(
//         url,
//         options: Options(headers: {'Authorization':'Bearer $token'}),
//       );
//       emit(SessionDeleted());
//     } on DioError catch(e) {
//       emit(SessionError(e.response?.data['message'] ?? e.message));
//     }
//   }
// }







import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';

import '../../../constant/endPoint/endPoints.dart';
import '../../../models/sessions/paginatedSessions.dart';
import '../../../network/remote/dioHelper.dart';
import '../../states/sessions/session.dart';

class SessionCubit extends Cubit<SessionState> {
  SessionCubit() : super(SessionInitial());

  Future<void> fetchSessions({
    required int sectionId,
  }) async {
    emit(SessionLoading());
    try {
      final url = GET_SECTION_SESSIONS.replaceFirst('{section_id}', '$sectionId');
      final res = await DioHelper.getData(url: url);
      final page = PaginatedSessions.fromJson(res.data['sessions']);
      emit(SessionsLoaded(page));
    } on DioError catch (e) {
      emit(SessionError(e.response?.data['message'] ?? e.message));
    }
  }

  Future<void> createSession({
    required String name,
    required DateTime sessionDate,
    required int courseSectionId,
  }) async {
    emit(SessionLoading());
    try {
      await DioHelper.postData(
        url: CREATE_SESSION,
        data: {
          'name': name,
          'session_date': sessionDate.toIso8601String(),
          'course_section_id': courseSectionId,
        },
        headers: {}, // التوكن يُضاف تلقائيًا من DioHelper
      );
      emit(SessionCreated());
    } on DioError catch (e) {
      emit(SessionError(e.response?.data['message'] ?? e.message));
    }
  }

  Future<void> updateSession({
    required int sessionId,
    required String name,
    required DateTime sessionDate,
  }) async {
    emit(SessionLoading());
    try {
      final url = UPDATE_SESSION.replaceFirst('{session_id}', '$sessionId');
      await DioHelper.putData(
        url: url,
        data: {
          'name': name,
          'session_date': sessionDate.toIso8601String(),
        },
      );
      emit(SessionUpdated());
    } on DioError catch (e) {
      emit(SessionError(e.response?.data['message'] ?? e.message));
    }
  }

  Future<void> deleteSession({
    required int sessionId,
  }) async {
    emit(SessionLoading());
    try {
      final url = DELETE_SESSION.replaceFirst('{session_id}', '$sessionId');
      await DioHelper.deleteData(url: url);
      emit(SessionDeleted());
    } on DioError catch (e) {
      emit(SessionError(e.response?.data['message'] ?? e.message));
    }
  }
}
