

import '../../../../../models/Home/Courses/files/FilesDetails.dart';

abstract class ShowFilesState {}

class ShowFilesInitial extends ShowFilesState {}

class ShowFilesLoading extends ShowFilesState {}

class ShowFilesLoaded extends ShowFilesState {
  final List<FileDetail> files;

  ShowFilesLoaded(this.files);
}

class ShowFilesError extends ShowFilesState {
  final String message;

  ShowFilesError(this.message);
}
