import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:trainer_section/Bloc/states/Home/Courses/ShowCourses.dart';

import '../../../../constant/endPoint/endPoints.dart';
import '../../../../models/Home/Courses/ShowCourses.dart';
import '../../../../network/remote/dioHelper.dart';


class CoursesCubit extends Cubit<CoursesState> {
  CoursesCubit() : super(CoursesInitial());

  Future<void> fetchMyCourses() async {
    emit(CoursesLoading());
    try {
      final response = await DioHelper.getData(url: SHOWCOURSES);
      print('=== raw response: ${response.data} ===');
      final model = CoursesResponse.fromJson(response.data as Map<String, dynamic>);
      print('=== parsed ${model.courses.length} sections ===');
      // final model = CoursesResponse.fromJson(response.data);
      emit(CoursesLoaded(model.courses));
    } on DioError catch (e) {
      emit(CoursesError(e.response?.statusMessage ?? e.message!));
    } catch (e) {
      emit(CoursesError(e.toString()));
    }
  }
}
