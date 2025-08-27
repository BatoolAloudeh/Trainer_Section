// lib/features/progress/data/models/section_progress_model.dart
class SectionProgressModel {
  final String message;
  final int progressPercentage;

  SectionProgressModel({
    required this.message,
    required this.progressPercentage,
  });

  factory SectionProgressModel.fromJson(Map<String, dynamic> json) {
    return SectionProgressModel(
      message: json['message'] as String? ?? '',
      progressPercentage: (json['progress_percentage'] as num?)?.toInt() ?? 0,
    );
  }
}
