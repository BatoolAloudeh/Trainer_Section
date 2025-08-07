

abstract class DeleteFileState {}

class DeleteFileInitial extends DeleteFileState {}

class DeleteFileLoading extends DeleteFileState {}

class DeleteFileSuccess extends DeleteFileState {
  final String message;

  DeleteFileSuccess(this.message);
}

class DeleteFileError extends DeleteFileState {
  final String message;

  DeleteFileError(this.message);
}
