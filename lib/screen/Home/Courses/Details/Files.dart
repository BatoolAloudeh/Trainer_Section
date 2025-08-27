

import 'dart:io';
import 'dart:typed_data';
import 'dart:html' as html;

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:trainer_section/constant/ui/Colors/colors.dart';

import '../../../../Bloc/cubit/Home/Courses/Files/delete.dart';
import '../../../../Bloc/cubit/Home/Courses/Files/showFiles.dart';
import '../../../../Bloc/cubit/Home/Courses/Files/update.dart';
import '../../../../Bloc/cubit/Home/Courses/Files/upload.dart';
import '../../../../Bloc/states/Home/Courses/Files/delete.dart';
import '../../../../Bloc/states/Home/Courses/Files/update.dart';
import '../../../../Bloc/states/Home/Courses/Files/upload.dart';
import '../../../../constant/constantKey/key.dart';
import '../../../../localization/app_localizations.dart';
import '../../../../models/Home/Courses/files/FilesDetails.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // Upload: رسالة نجاح/فشل مرة واحدة فقط
        BlocListener<UploadFileCubit, UploadFileState>(
          listener: (ctx, state) {
            if (state is UploadFileSuccess) {
              ctx.read<ShowFilesCubit>().fetchFilesInSection(widget.sectionId, widget.token);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(AppLocalizations.of(context)?.translate("file_uploaded_successfully") ?? "File uploaded successfully")),
              );
            } else if (state is UploadFileError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${AppLocalizations.of(context)?.translate("upload_failed") ?? "Upload failed"}: ${state.message}')),
              );
            }
          },
        ),

        // Update: رسالة نجاح/فشل مرة واحدة فقط
        BlocListener<UpdateFileCubit, UpdateFileState>(
          listenWhen: (prev, curr) => curr is UpdateFileSuccess || curr is UpdateFileError,
          listener: (ctx, state) {
            if (state is UpdateFileSuccess) {
              widget.onFilesChanged();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(AppLocalizations.of(context)?.translate("file_updated_successfully") ?? "File updated successfully")),
              );
            } else if (state is UpdateFileError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
        ),

        // Delete: رسالة نجاح/فشل مرة واحدة فقط
        BlocListener<DeleteFileCubit, DeleteFileState>(
          listenWhen: (prev, curr) => curr is DeleteFileSuccess || curr is DeleteFileError,
          listener: (ctx, state) {
            if (state is DeleteFileSuccess) {
              widget.onFilesChanged();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            } else if (state is DeleteFileError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),

          // ====== Toolbar (count + new file) ======
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.folder, color: AppColors.darkBlue, size: 22.sp),
                  SizedBox(width: 8.w),
                  Text(
                    '${widget.files.length} ${AppLocalizations.of(context)?.translate("files") ?? "Files"}',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.darkBlue,
                    ),
                  ),
                ],
              ),

              ElevatedButton.icon(
                onPressed: () => _onUploadPressed(context),
                icon: Icon(Icons.add, size: 18.sp),
                label: Text(
                  AppLocalizations.of(context)?.translate("new_file") ?? "New File",
                  style: TextStyle(fontSize: 14.sp),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.purple,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22.r),
                  ),
                  elevation: 2,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // ====== Content ======
          Expanded(
            child: widget.files.isEmpty
                ? _buildEmpty()
                : ListView.separated(
              itemCount: widget.files.length,
              separatorBuilder: (_, __) => SizedBox(height: 12.h),
              itemBuilder: (context, i) {
                final file = widget.files[i];
                return Card(
                  elevation: 2,
                  shadowColor: Colors.black12,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                    leading: _FileIconBadge(fileName: file.fileName),
                    title: Text(
                      file.fileName,
                      style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Edit button (عرض فقط)
                        BlocBuilder<UpdateFileCubit, UpdateFileState>(
                          builder: (ctx, state) {
                            final loading = state is UpdateFileLoading;
                            return Tooltip(
                              message: AppLocalizations.of(context)?.translate("edit") ?? 'Edit',
                              child: _CircleIconButton(
                                icon: loading ? Icons.hourglass_top : Icons.edit_rounded,
                                color: AppColors.purple,
                                onTap: loading ? null : () => _onEditPressed(context, file.id),
                              ),
                            );
                          },
                        ),
                        SizedBox(width: 10.w),

                        // Delete button (عرض فقط)
                        BlocBuilder<DeleteFileCubit, DeleteFileState>(
                          builder: (ctx, state) {
                            final loading = state is DeleteFileLoading;
                            return Tooltip(
                              message: AppLocalizations.of(context)?.translate("delete") ?? 'Delete',
                              child: _CircleIconButton(
                                icon: loading ? Icons.hourglass_top : Icons.delete_outline_rounded,
                                color: AppColors.orange,
                                onTap: loading
                                    ? null
                                    : () async {
                                  final confirm = await _confirmDelete(context, file.fileName);
                                  if (confirm != true) return;
                                  ctx.read<DeleteFileCubit>().deleteFile(
                                    token: widget.token,
                                    fileId: file.id,
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    onTap: () => _openFile(file),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ====== Empty state with a nice look ======
  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 160.h,
            child: Image.asset(
              'assets/Images/no notification.png',
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            AppLocalizations.of(context)?.translate("nothing_to_display") ?? 'Nothing to display at this time',

            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.orange,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 6.h),
          Text(
            AppLocalizations.of(context)?.translate("click_new_file_to_upload") ?? 'Click “New File” to upload',
            style: TextStyle(fontSize: 14.sp, color: AppColors.t2),
          ),
        ],
      ),
    );
  }

  // ====== circular action button ======
  Widget _CircleIconButton({
    required IconData icon,
    required Color color,
    VoidCallback? onTap,
  }) {
    return Material(
      color: color.withOpacity(0.12),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(8.r),
          child: Icon(icon, color: color, size: 20.sp),
        ),
      ),
    );
  }

  // ====== file leading icon with extension badge ======
  // شكلي فقط
  Widget _FileIconBadge({required String fileName}) {
    final ext = fileName.split('.').length > 1 ? fileName.split('.').last.toUpperCase() : '';
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: AppColors.purple.withOpacity(0.10),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(Icons.insert_drive_file_rounded, color: AppColors.purple, size: 22.sp),
        ),
        if (ext.isNotEmpty)
          Positioned(
            right: -6.w,
            bottom: -6.h,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: AppColors.purple,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.white, width: 1),
              ),
              child: Text(
                ext,
                style: TextStyle(fontSize: 9.sp, color: Colors.white, fontWeight: FontWeight.w700),
              ),
            ),
          ),
      ],
    );
  }

  Future<bool?> _confirmDelete(BuildContext context, String name) async {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(context)?.translate("delete_file") ?? 'Delete file'),
        content: Text('${AppLocalizations.of(context)?.translate("are_you_sure_delete_file") ?? 'Are you sure you want to delete'} “$name”?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(AppLocalizations.of(context)?.translate("cancel") ?? 'Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(AppLocalizations.of(context)?.translate("delete") ?? 'Delete', style: TextStyle(color: AppColors.orange)),
          ),
        ],
      ),
    );
  }

  Future<void> _openFile(FileDetail file) async {
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
        dio.options.headers['Authorization'] = 'Bearer ${widget.token}';
        await dio.download(url, localPath);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${AppLocalizations.of(context)?.translate("download_failed") ?? "Download failed"}: $e')),
        );
        return;
      }
    }

    final result = await OpenFile.open(localPath);
    if (result.type != ResultType.done) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${AppLocalizations.of(context)?.translate("cannot_open_file") ?? "Cannot open file"}: ${result.message}')),
      );
    }
  }

  Future<void> _onUploadPressed(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any, withData: true);
    if (result != null && result.files.single.bytes != null) {
      final fileBytes = result.files.single.bytes!;
      final fileName = result.files.single.name;
      final cubit = context.read<UploadFileCubit>();
      final detail = await cubit.uploadFile(
        courseSectionId: widget.sectionId,
        fileBytes: fileBytes,
        token: widget.token,
        fileName: fileName,
      );
      if (detail != null) {
        context.read<ShowFilesCubit>().fetchFilesInSection(widget.sectionId, widget.token);
      }
    }
  }

  Future<void> _onEditPressed(BuildContext context, int fileId) async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any, withData: true);
    if (result != null && result.files.single.bytes != null) {
      final fileBytes = result.files.single.bytes!;
      final fileName = result.files.single.name;
      final cubit = context.read<UpdateFileCubit>();
      final detail = await cubit.updateFile(
        fileId: fileId,
        courseSectionId: widget.sectionId,
        fileBytes: fileBytes,
        token: widget.token,
        fileName: fileName,
      );
      if (detail != null) widget.onFilesChanged();
    }
  }
}
