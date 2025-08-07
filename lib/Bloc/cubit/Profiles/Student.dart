import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:trainer_section/Bloc/states/Profiles/Student.dart';
import '../../../constant/constantKey/key.dart';
import '../../../constant/endPoint/endPoints.dart';
import '../../../models/Grades/UserForGrade.dart';

// lib/bloc/cubit/student_cubit.dart

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';

import '../../../network/local/cacheHelper.dart';
import '../../../network/remote/dioHelper.dart';


class StudentCubit extends Cubit<StudentState> {
  StudentCubit() : super(StudentInitial());


  Future<void> fetchStudent({
    required int studentId,
  }) async {
    emit(StudentLoading());
    try {
      final token = CacheHelper.getData(key: TOKENKEY) as String?;
      if (token == null) {
        emit(StudentError('Missing auth token'));
        return;
      }

      final url = '$SHOW_STUDENT_BY_ID/$studentId';

      final res = await DioHelper.getData(
        url: url,
        headers: {'Authorization': 'Bearer $token'},
      );


      final json = res.data['student'] as Map<String, dynamic>?;
      if (json == null) {
        emit(StudentError('Malformed response'));
        return;
      }

      final student = StudentModel.fromJson(json);
      emit(StudentLoaded(student));

    } on DioError catch (e) {
      final msg = e.response?.data['message'] as String? ?? e.message;
      emit(StudentError(msg!));
    } catch (e) {
      emit(StudentError(e.toString()));
    }
  }
}

