import 'package:equatable/equatable.dart';
import '../../../models/Profiles/Trainer.dart';


abstract class TrainerProfileState extends Equatable {
  const TrainerProfileState();
  @override List<Object?> get props => [];
}

class TrainerProfileInitial extends TrainerProfileState {}

class TrainerProfileLoading extends TrainerProfileState {}

class TrainerProfileLoaded extends TrainerProfileState {
  final TrainerProfileModel profile;
  const TrainerProfileLoaded(this.profile);
  @override List<Object?> get props => [profile];
}

class TrainerProfileError extends TrainerProfileState {
  final String message;
  const TrainerProfileError(this.message);
  @override List<Object?> get props => [message];
}
