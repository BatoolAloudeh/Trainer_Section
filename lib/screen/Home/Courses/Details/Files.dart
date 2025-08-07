import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:trainer_section/constant/ui/Colors/colors.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../Bloc/cubit/Home/Courses/Files/delete.dart';
import '../../../../Bloc/cubit/Home/Courses/Files/showFiles.dart';
import '../../../../Bloc/cubit/Home/Courses/Files/update.dart';
import '../../../../Bloc/cubit/Home/Courses/Files/upload.dart';
import '../../../../Bloc/states/Home/Courses/Files/delete.dart';
import '../../../../Bloc/states/Home/Courses/Files/update.dart';
import '../../../../Bloc/states/Home/Courses/Files/upload.dart';
import '../../../../constant/constantKey/key.dart';
import '../../../../models/Home/Courses/files/FilesDetails.dart';
import 'dart:typed_data';
import 'dart:html' as html;

class FilesSection extends StatefulWidget {
  final List<FileDetail> files;
  final int sectionId;
  final String token;
  final VoidCallback onFilesChanged;

  const FilesSection({
    Key? key,
    required this.files,
    required this.sectionId,
    required this.token,
    required this.onFilesChanged,
  }) : super(key: key);
  @override
  State<FilesSection> createState() => _FilesSectionState();
}

class _FilesSectionState extends State<FilesSection> {

  late final ShowFilesCubit _showFilesCubit;
  late final UploadFileCubit _uploadFileCubit;

  @override
  void initState() {
    super.initState();
    _showFilesCubit = context.read<ShowFilesCubit>();
    _uploadFileCubit = context.read<UploadFileCubit>();
    // أول تحميل

  }
  @override
  Widget build(BuildContext context) {

    return
      BlocListener<UploadFileCubit, UploadFileState>(
          listener: (ctx, state) {
            if (state is UploadFileSuccess) {
              ctx.read<ShowFilesCubit>().fetchFilesInSection(widget.sectionId, widget.token);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('File uploaded successfully')),
              );
            }

        if (state is UploadFileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Upload failed: ${state.message}')),
          );
        }
      },
      child:

      Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 12.h),
        Text(
          'You have ${widget.files.length} Files',
          style: TextStyle(fontSize: 16.sp, color: AppColors.t3),
        ),
        SizedBox(height: 20.h),


        ElevatedButton(
          onPressed: () => _onUploadPressed(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.purple,
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
          ),
          child: Text('+ New File', style: TextStyle(fontSize: 14.sp)),
        ),
        SizedBox(height: 20.h),

        // قائمة الملفات
        Expanded(
          child: ListView.separated(
            itemCount: widget.files.length,
            separatorBuilder: (_, __) => SizedBox(height: 16.h),
            itemBuilder: (context, i) {
              final file = widget.files[i];
              return ListTile(
                leading: Icon(
                  Icons.insert_drive_file,
                  color: AppColors.purple,
                  size: 28.sp,
                ),
                title: Text(
                  file.fileName,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    BlocConsumer<DeleteFileCubit, DeleteFileState>(
                      listener: (ctx, state) {
                        if (state is DeleteFileSuccess) {
                        widget. onFilesChanged();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.message)),
                          );
                        }
                      },
                      builder: (ctx, state) {
                        final loading = state is DeleteFileLoading;
                        return IconButton(
                          icon: loading
                              ? const CircularProgressIndicator(strokeWidth: 2)
                              : Icon(Icons.delete_outline,
                              color: AppColors.orange, size: 24.sp),
                          onPressed: loading
                              ? null
                              : () {
                            ctx.read<DeleteFileCubit>().deleteFile(
                              token:widget. token,
                              fileId: file.id,
                            );
                          },
                        );
                      },
                    ),
                    SizedBox(width: 12.w),


                    BlocConsumer<UpdateFileCubit, UpdateFileState>(
                      listener: (ctx, state) {
                        if (state is UpdateFileSuccess) {
                          widget.onFilesChanged();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'File has been updated successfully')),
                          );
                        }
                      },
                      builder: (ctx, state) {
                        final loading = state is UpdateFileLoading;
                        return IconButton(
                          icon: loading
                              ? const CircularProgressIndicator(strokeWidth: 2)
                              : Icon(Icons.edit_outlined,
                              color: AppColors.purple, size: 24.sp),
                          onPressed: loading
                              ? null
                              : () => _onEditPressed(context, file.id),
                        );
                      },
                    ),
                  ],
                ),
                onTap: () async {

                  String rawPath = file.filePath;
                  if (rawPath.startsWith('/')) rawPath = rawPath.substring(1);

                  final host = kIsWeb
                      ? 'http://127.0.0.1:8000'
                      : Platform.isAndroid
                      ? 'http://10.0.2.2:8000'
                      : 'http://127.0.0.1:8000';
                  final url = '$host/$rawPath';


                  final ext = file.fileName.split('.').last.toLowerCase();


                  if (kIsWeb) {
                    if (ext == 'pdf') {

                      html.window.open(url, '_blank');
                    } else {
                      // نزّل Word/Excel/PPT
                      final anchor = html.AnchorElement(href: url)
                        ..setAttribute('download', file.fileName)
                        ..click();
                    }
                    return;
                  }


                  final tempDir = await getTemporaryDirectory();
                  final localPath = '${tempDir.path}/${file.fileName}';
                  final localFile = File(localPath);

                  if (!await localFile.exists()) {
                    try {
                      final dio = Dio();
                      dio.options.headers['Authorization'] = 'Bearer $widget.token';
                      await dio.download(
                        url,
                        localPath,
                        onReceiveProgress: (rec, total) {
                          // اختياريًا: progress
                        },
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Download failed: $e')),
                      );
                      return;
                    }
                  }


                  final result = await OpenFile.open(localPath);
                  if (result.type != ResultType.done) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Cannot open file: ${result.message}')),
                    );
                  }
                },


              );
            },
          ),
        ),
      ],),
    );
  }

  Future<void> _onUploadPressed(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      withData: true,
    );
    if (result != null && result.files.single.bytes != null) {
      final fileBytes = result.files.single.bytes!;
      final fileName = result.files.single.name;
      final cubit = context.read<UploadFileCubit>();
      final detail = await cubit.uploadFile(
        courseSectionId:widget.sectionId,
        fileBytes: fileBytes,
        token: widget.token,
        fileName: fileName,
      );

      if (detail != null) {
        context.read<ShowFilesCubit>()
            .fetchFilesInSection(widget.sectionId, widget.token);
      }
    }
  }

  Future<void> _onEditPressed(
      BuildContext context, int fileId) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      withData: true,
    );
    if (result != null && result.files.single.bytes != null) {
      final fileBytes = result.files.single.bytes!;
      final fileName = result.files.single.name;
      final cubit = context.read<UpdateFileCubit>();
      final detail = await cubit.updateFile(
        fileId: fileId,
        courseSectionId:widget. sectionId,
        fileBytes: fileBytes,
        token:widget. token,
        fileName: fileName,
      );
      if (detail != null) widget.onFilesChanged();
    }
  }
}
