// lib/features/progress/presentation/manager/section_progress_state.dart
import '../../../models/progress/progress.dart';


abstract class SectionProgressState {}

class SectionProgressInitial extends SectionProgressState {}

class SectionProgressLoading extends SectionProgressState {}

class SectionProgressSuccess extends SectionProgressState {
  final SectionProgressModel data;
  SectionProgressSuccess(this.data);
}

class SectionProgressFailure extends SectionProgressState {
  final String message;
  SectionProgressFailure(this.message);
}
