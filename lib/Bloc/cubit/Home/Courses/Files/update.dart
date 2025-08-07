
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trainer_section/constant/endPoint/endPoints.dart';
import '../../../../../models/Home/Courses/files/FilesDetails.dart';
import '../../../../../network/remote/dioHelper.dart';
import '../../../../states/Home/Courses/Files/update.dart';
import 'dart:typed_data';
import 'package:dio/dio.dart' as dio_pkg;
import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dio_pkg;
import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dio_pkg;
import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dio_pkg;
import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dio_pkg;
import 'package:dio/dio.dart';


class UpdateFileCubit extends Cubit<UpdateFileState> {
  UpdateFileCubit() : super(UpdateFileInitial());

  static UpdateFileCubit get(context) => BlocProvider.of(context);

  Future<FileDetail?> updateFile({
    required int fileId,
    required int courseSectionId,
    required Uint8List fileBytes,
    required String token,
    required String fileName,
  }) async {
    emit(UpdateFileLoading());

    try {

      print("===== UpdateFileCubit.updateFile() called =====");
      print("  courseSectionId = $courseSectionId");
      print("  fileId          = $fileId");
      print("  fileName        = $fileName");
      print("  fileBytes.length= ${fileBytes.length} bytes");
      print("  token (first 20 chars) = ${token.substring(0, 20)}...");


      FormData formData = FormData.fromMap({
        'course_section_id': courseSectionId,
        'file': dio_pkg.MultipartFile.fromBytes(
          fileBytes,
          filename: fileName,
        ),
        'file_Id': fileId,
      });


      print("----- FormData content -----");
      formData.fields.forEach((field) {
        print("  Field: ${field.key} = ${field.value}");
      });
      formData.files.forEach((file) {
        print("  File field: ${file.key} => filename=${file.value.filename}, length=${file.value.length}");
      });
      print("-----------------------------");


      final response = await DioHelper.postFormData(
        url: UPDATEFILE,
        formData: formData,
        options: Options(headers: {
          'Authorization': 'Bearer $token',

        }),
      );

      print("===== UpdateFile Response (status=${response.statusCode}) =====");
      print(response.data);
      print("==============================================================");


      if (response.statusCode == 200|| response.statusCode == 201) {
        final fileDetail = FileDetail.fromJson(response.data['file']);
        emit(UpdateFileSuccess(fileDetail));
        return fileDetail;
      } else {
        final errorMessage =
            response.data['message'] ?? "Failed to update file";
        emit(UpdateFileError(errorMessage));
        return null;
      }
    } on DioError catch (error) {

      print("===== DioError in UpdateFileCubit =====");
      if (error.response != null) {
        print("  Response data: ${error.response?.data}");
        print("  Response status: ${error.response?.statusCode}");
      }
      print(error);
      final msg =
          error.response?.data['message'] ?? error.message;
      emit(UpdateFileError(msg));
      return null;
    } catch (e) {
      print("===== Exception in UpdateFileCubit =====");
      print(e);
      emit(UpdateFileError(e.toString()));
      return null;
    }
  }
}
