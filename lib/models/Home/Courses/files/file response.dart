// // lib/models/Home/courses/files/FilesResponse.dart

import 'FilesDetails.dart';
//
// class FilesResponse {
//   final List<FileDetail> data;
//   final int currentPage;
//   final int lastPage;
//   // يمكنك إضافة حقول برمجية أخرى مثل `total`, `per_page` إذا أردت التعامل مع pagination لاحقًا
//
//   FilesResponse({
//     required this.data,
//     required this.currentPage,
//     required this.lastPage,
//   });
//
//   factory FilesResponse.fromJson(Map<String, dynamic> json) {
//     // لاحظ أنّ الجذر هو "Files" ثم "data"
//     final filesJson = (json['Files']['data'] as List);
//     return FilesResponse(
//       data: filesJson.map((e) => FileDetail.fromJson(e)).toList(),
//       currentPage: json['Files']['current_page'] ?? 1,
//       lastPage: json['Files']['last_page'] ?? 1,
//     );
//   }
// }






class FilesResponse {
  final List<FileDetail> data;

  FilesResponse({ required this.data });

  /// من المفترض أن يستخرج json["Files"]["data"]، لا json["data"] مباشرة
  factory FilesResponse.fromJson(Map<String, dynamic> json) {
    final filesWrapper = json['Files'] as Map<String, dynamic>?;

    if (filesWrapper == null) {
      throw Exception("Key 'Files' not found in JSON");
    }

    final list = filesWrapper['data'] as List<dynamic>?;

    if (list == null) {
      throw Exception("Key 'data' not found under 'Files' in JSON");
    }

    return FilesResponse(
      data: list.map((e) => FileDetail.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}
