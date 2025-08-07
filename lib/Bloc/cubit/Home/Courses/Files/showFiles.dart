// lib/view_model/cubit/home/files/show_files_cubit.dart

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:trainer_section/constant/endPoint/endPoints.dart';

import '../../../../../models/Home/Courses/files/FilesDetails.dart';
import '../../../../../network/remote/dioHelper.dart';
import '../../../../states/Home/Courses/Files/showFiles.dart';

class ShowFilesCubit extends Cubit<ShowFilesState> {
  ShowFilesCubit() : super(ShowFilesInitial());


  Future<void> fetchFilesInSection(int sectionId, String token) async {
    emit(ShowFilesLoading());
    try {
      final Response response = await DioHelper.getData(
        url: '$SHOWFILES/$sectionId',
      );


      final List<dynamic> rawList =
      (response.data['Files']['data'] as List<dynamic>);
      final filesList =
      rawList.map((json) => FileDetail.fromJson(json)).toList();

      emit(ShowFilesLoaded(filesList));
    } on DioError catch (e) {
      final msg = e.response?.data['message'] ?? e.message;
      emit(ShowFilesError(msg));
    } catch (e) {
      emit(ShowFilesError(e.toString()));
    }
  }
}

