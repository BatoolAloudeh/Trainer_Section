// lib/Bloc/states/Home/Courses/Files/uploadFile.dart

import '../../../../../models/Home/Courses/files/FilesDetails.dart';


abstract class UploadFileState {}

class UploadFileInitial extends UploadFileState {}

class UploadFileLoading extends UploadFileState {}

class UploadFileSuccess extends UploadFileState {
  final FileDetail fileDetail;

  UploadFileSuccess(this.fileDetail);
}

class UploadFileError extends UploadFileState {
  final String message;

  UploadFileError(this.message);
}
