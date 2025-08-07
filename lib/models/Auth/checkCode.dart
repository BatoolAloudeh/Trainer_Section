
class CheckCodeModel {
  final String message;

  CheckCodeModel({required this.message});

  factory CheckCodeModel.fromJson(Map<String, dynamic> json) {
    return CheckCodeModel(
      message: json['Message'] as String,
    );
  }
}
