// lib/features/progress/presentation/manager/section_progress_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';

import '../../../models/progress/progress.dart';
import '../../../network/remote/dioHelper.dart';
import '../../states/progress/progress.dart';



class SectionProgressCubit extends Cubit<SectionProgressState> {
  SectionProgressCubit() : super(SectionProgressInitial());

  Future<void> fetchSectionProgress({required int sectionId}) async {
    emit(SectionProgressLoading());
    try {
      // الـ DioHelper عندك يضيف Authorization: Bearer تلقائياً عبر الـ interceptor
      final res = await DioHelper.getData(
        url: '/course-sections/$sectionId/progress',
      );

      final model = SectionProgressModel.fromJson(res.data as Map<String, dynamic>);
      emit(SectionProgressSuccess(model));
    } on DioException catch (e) {
      final msg = e.response?.data is Map<String, dynamic>
          ? ((e.response!.data['message'] as String?) ?? 'Network error')
          : (e.message ?? 'Network error');
      emit(SectionProgressFailure(msg));
    } catch (e) {
      emit(SectionProgressFailure(e.toString()));
    }
  }
}
