import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:trainer_section/constant/endPoint/endPoints.dart';
import '../../../constant/constantKey/key.dart';
import '../../../models/Profiles/Trainer.dart';
import '../../../network/remote/dioHelper.dart';
import '../../states/Profiles/Trainer.dart';



class TrainerProfileCubit extends Cubit<TrainerProfileState> {
  TrainerProfileCubit() : super(TrainerProfileInitial());

  Future<void> fetchProfile() async {
    emit(TrainerProfileLoading());
    try {
      final resp = await DioHelper.getData(
        url: TRAINERPROFILE,
      );
      final json = resp.data['profile'] as Map<String, dynamic>;
      final profile = TrainerProfileModel.fromJson(json);
      emit(TrainerProfileLoaded(profile));
    } on DioError catch (e) {
      final msg = e.response?.data['message'] as String? ?? e.message;
      emit(TrainerProfileError(msg!));
    } catch (e) {
      emit(TrainerProfileError(e.toString()));
    }
  }
}
