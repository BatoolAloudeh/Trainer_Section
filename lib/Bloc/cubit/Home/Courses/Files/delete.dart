// lib/view_model/cubit/home/files/delete_file_cubit.dart

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trainer_section/constant/endPoint/endPoints.dart';

import '../../../../../network/remote/dioHelper.dart';
import '../../../../states/Home/Courses/Files/delete.dart';

//
// class DeleteFileCubit extends Cubit<DeleteFileState> {
//   DeleteFileCubit() : super(DeleteFileInitial());
//
//   /// Delete file by ID
//   Future<void> deleteFile(int fileId) async {
//     emit(DeleteFileLoading());
//     try {
//       final Response response = await DioHelper.dio.post(
//         '$DELETEFILE/$fileId',
//       );
//       final message = response.data['message'] ?? 'Deleted successfully';
//       emit(DeleteFileSuccess(message));
//     } on DioError catch (e) {
//       emit(DeleteFileError(e.response?.data['message'] ?? e.message));
//     } catch (e) {
//       emit(DeleteFileError(e.toString()));
//     }
//   }
// }

//
// class DeleteFileCubit extends Cubit<DeleteFileState> {
//   DeleteFileCubit() : super(DeleteFileInitial());
//
//   static DeleteFileCubit get(context) => BlocProvider.of(context);
//
//   Future<void> deleteFile({
//     required String token,
//     required int file_Id,
//   }) async {
//     emit(DeleteFileLoading());
//     try {
//       final response = await DioHelper.dio.post(
//         '$DELETEFILE/$file_Id', // لاحظ أنّ المسار هو POST وليس DELETE حسب Postman
//         options: Options(
//           headers: {
//             'Authorization': 'Bearer $token',
//             'Accept': 'application/json',
//           },
//         ),
//       );
//       // استجابة Postman كانت بالشكل: { "message": "File has been deleted successfully " }
//       if (response.statusCode == 200) {
//         final message = response.data['message'] ?? 'Deleted successfully';
//         emit(DeleteFileSuccess(message));
//       } else {
//         final err = response.data['message'] ?? 'Failed to delete file';
//         emit(DeleteFileError(err));
//       }
//     } on DioError catch (e) {
//       final msg = (e.response?.data['message'] ?? e.message).toString();
//       emit(DeleteFileError(msg));
//     } catch (e) {
//       emit(DeleteFileError(e.toString()));
//     }
//   }
// }




// lib/view_model/cubit/home/files/delete_file_cubit.dart

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';


class DeleteFileCubit extends Cubit<DeleteFileState> {
  DeleteFileCubit() : super(DeleteFileInitial());

  static DeleteFileCubit get(context) => BlocProvider.of(context);

  Future<void> deleteFile({
    required String token,
    required int fileId,
  }) async {
    emit(DeleteFileLoading());
    try {

      final response = await DioHelper.dio.post(
        '$DELETEFILE/$fileId',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );


      if (response.statusCode == 200) {
        final message =
            response.data['message'] ?? 'File has been deleted successfully';
        emit(DeleteFileSuccess(message));
      } else {
        final errorMessage =
            response.data['message'] ?? 'Failed to delete file';
        emit(DeleteFileError(errorMessage));
      }
    } on DioError catch (error) {
      final msg = error.response?.data['message'] ?? error.message;
      emit(DeleteFileError(msg));
    } catch (e) {
      emit(DeleteFileError(e.toString()));
    }
  }
}
