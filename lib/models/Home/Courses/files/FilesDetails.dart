// lib/models/Home/courses/files/FilesDetails.dart
//
// class FileDetail {
//   final int id;
//   final String fileName;
//   final String filePath;
//   final int courseSectionId;
//   final DateTime createdAt;
//   final DateTime updatedAt;
//
//   FileDetail({
//     required this.id,
//     required this.fileName,
//     required this.filePath,
//     required this.courseSectionId,
//     required this.createdAt,
//     required this.updatedAt,
//   });
//
//   factory FileDetail.fromJson(Map<String, dynamic> json) {
//     return FileDetail(
//       id: json['id'],
//       fileName: json['file_name'],
//       filePath: json['file_path'],
//       courseSectionId: int.parse(json['course_section_id'].toString()),
//       createdAt: DateTime.parse(json['created_at']),
//       updatedAt: DateTime.parse(json['updated_at']),
//     );
//   }
// }


class FileDetail {
  final int id;
  final String fileName;
  final String filePath;
  final int courseSectionId;
  final String createdAt;
  final String updatedAt;

  FileDetail({
    required this.id,
    required this.fileName,
    required this.filePath,
    required this.courseSectionId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FileDetail.fromJson(Map<String, dynamic> json) {
    return FileDetail(
      id: json['id'] as int,
      fileName: json['file_name'] as String,
      filePath: json['file_path'] as String,
      courseSectionId: int.parse(json['course_section_id'].toString()),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }
}