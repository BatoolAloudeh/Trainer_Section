// lib/Bloc/states/Home/Courses/Files/updateFile.dart

import '../../../../../models/Home/Courses/files/FilesDetails.dart';


abstract class UpdateFileState {}

class UpdateFileInitial extends UpdateFileState {}

class UpdateFileLoading extends UpdateFileState {}

class UpdateFileSuccess extends UpdateFileState {
  final FileDetail fileDetail;

  UpdateFileSuccess(this.fileDetail);
}

class UpdateFileError extends UpdateFileState {
  final String message;

  UpdateFileError(this.message);
}
