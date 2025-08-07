import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import '../../../../constant/endPoint/endPoints.dart';
import '../../../../models/Home/Courses/showStudentsInSections.dart';
import '../../../../network/remote/dioHelper.dart';
import '../../../states/Home/Courses/showStudentsInSections.dart';

class StudentsInSectionCubit extends Cubit<StudentsInSectionState> {
  StudentsInSectionCubit() : super(StudentsInSectionInitial());


  Future<void> fetchStudentsInSection(int sectionId, String token) async {
    emit(StudentsInSectionLoading());
    try {
      final Response response = await DioHelper.getData(
        url: '$GET_STUDENTS_IN_SECTION/$sectionId',
      );

      final model = StudentsInSectionResponse.fromJson(response.data);

      emit(StudentsInSectionLoaded(model.students));
    } on DioError catch (err) {
      emit(StudentsInSectionError(err.response?.statusMessage ?? err.message!));
    } catch (e) {
      emit(StudentsInSectionError(e.toString()));
    }
  }
}
