class ForgotPasswordResponse {
  final String message;

  ForgotPasswordResponse({required this.message});

  factory ForgotPasswordResponse.fromJson(Map<String, dynamic> json) {
    // في بعض السيرفرات الحقل اسمه "mes"
    final msg = (json['message'] ?? json['mes'] ?? '').toString();
    return ForgotPasswordResponse(message: msg);
  }
}
