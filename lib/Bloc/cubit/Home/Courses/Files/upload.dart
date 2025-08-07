
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trainer_section/constant/endPoint/endPoints.dart';
import '../../../../../models/Home/Courses/files/FilesDetails.dart';
import '../../../../../network/remote/dioHelper.dart';
import '../../../../states/Home/Courses/Files/upload.dart';
//
//
// class UploadFileCubit extends Cubit<UploadFileState> {
//   UploadFileCubit() : super(UploadFileInitial());
//
//   /// Upload a file (multipart/form-data)
//   Future<void> uploadFile({
//     required int courseSectionId,
//     required dio_pkg.MultipartFile file,
//   }) async {
//     emit(UploadFileLoading());
//     try {
//       final formData = dio_pkg.FormData.fromMap({
//         'course_section_id': courseSectionId,
//         'file': file,
//       });
//       final Response response = await DioHelper.postFormData(
//         url:UPLOADFILE,
//         formData: formData,
//       );
//       final fileDetail = FileDetail.fromJson(response.data['file']);
//       emit(UploadFileSuccess(fileDetail));
//     } on DioError catch (e) {
//       emit(UploadFileError(e.response?.data['message'] ?? e.message));
//     } catch (e) {
//       emit(UploadFileError(e.toString()));
//     }
//   }
// }

//
// // lib/Bloc/cubit/Home/Courses/Files/uploadFile.dart
//
// import 'dart:typed_data';
// import 'package:bloc/bloc.dart';
// import 'package:dio/dio.dart';
//
//
// class UploadFileCubit extends Cubit<UploadFileState> {
//   UploadFileCubit() : super(UploadFileInitial());
//
//   static UploadFileCubit get(context) => BlocProvider.of(context);
//
//   Future<void> addFile({
//     required int course_section_id,
//     required Uint8List file,
//     required String token,
//   }) async {
//     emit(UploadFileLoading());
//     try {
//       final formData = FormData.fromMap({
//         'course_section_id': course_section_id,
//         'file': MultipartFile.fromBytes(file),
//       });
//
//       final response = await DioHelper.dio.post(
//         UPLOADFILE,
//         data: formData,
//         options: Options(
//           headers: {
//             'Authorization': 'Bearer $token',
//             'Accept': 'application/json',
//           },
//         ),
//       );
//
//       if (response.statusCode == 200) {
//         final fileDetail = FileDetail.fromJson(response.data['file']);
//         emit(UploadFileSuccess(fileDetail));
//       } else {
//         final err = response.data['message'] ?? 'Failed to upload file';
//         emit(UploadFileError(err));
//       }
//     } on DioError catch (e) {
//       final msg = (e.response?.data['message'] ?? e.message).toString();
//       emit(UploadFileError(msg));
//     } catch (e) {
//       emit(UploadFileError(e.toString()));
//     }
//   }
// }






// lib/view_model/cubit/home/files/upload_file_cubit.dart

import 'dart:typed_data';
import 'package:dio/dio.dart' as dio_pkg;
import 'package:dio/dio.dart';


class UploadFileCubit extends Cubit<UploadFileState> {
  UploadFileCubit() : super(UploadFileInitial());

  static UploadFileCubit get(context) => BlocProvider.of(context);


  Future<FileDetail?> uploadFile({
    required int courseSectionId,
    required Uint8List fileBytes,
    required String token,
    required String fileName,
  }) async {
    emit(UploadFileLoading());
    try {

      FormData formData = FormData.fromMap({
        'course_section_id': courseSectionId.toString(),
        'file': dio_pkg.MultipartFile.fromBytes(fileBytes, filename: fileName),
      });

      final response = await DioHelper.postFormData(
        url: UPLOADFILE,
        formData: formData,
        options: Options(headers: {
          'Authorization': 'Bearer $token',

        }),
      );


      if (response.statusCode == 200 || response.statusCode == 201) {
        final fileDetail = FileDetail.fromJson(response.data['file']);
        emit(UploadFileSuccess(fileDetail));
        return fileDetail;
      } else {
        final errorMessage =
            response.data['message'] ?? "Unknown error occurred";
        emit(UploadFileError(errorMessage));
        return null;
      }
    } on DioError catch (error) {
      final msg = error.response?.data['message'] ?? error.message;
      emit(UploadFileError(msg));
      return null;
    } catch (e) {
      emit(UploadFileError(e.toString()));
      return null;
    }
  }
}
