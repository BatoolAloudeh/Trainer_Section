import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:trainer_section/screen/Home/Courses/AddExamsAndMarks/Marks.dart';

import '../../../../Bloc/cubit/Exams/Exam.dart';
import '../../../../Bloc/states/Exams/Exam.dart';
import '../../../../constant/ui/Colors/colors.dart';
import '../../../../constant/ui/General constant/ConstantUi.dart';
import '../../../../localization/app_localizations.dart';
import '../../../../models/Exams/Exam.dart';

class ExamsOverviewPage extends StatefulWidget {
  final List<Map<String, String>> students;
  final int sectionId;
  final int trainerId;
  final String token;

  const ExamsOverviewPage({
    Key? key,
    required this.students,
    required this.sectionId,
    required this.trainerId,
    required this.token,
  }) : super(key: key);

  @override
  State<ExamsOverviewPage> createState() => _ExamsOverviewPageState();
}

class _ExamsOverviewPageState extends State<ExamsOverviewPage> {
  late ExamCubit _examCubit;

  @override
  void initState() {
    super.initState();
    _examCubit = ExamCubit()..fetchExams(sectionId: widget.sectionId);
  }

  @override
  void dispose() {
    _examCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(1440, 1024), minTextAdapt: true);

    return BlocProvider.value(
      value: _examCubit,
      child: BlocListener<ExamCubit, ExamState>(
        listener: (ctx, state) {
          if (state is ExamCreated || state is ExamUpdated) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pop();
            });
            _examCubit.fetchExams(sectionId: widget.sectionId);
          }
          if (state is ExamDeleted) {
            _examCubit.fetchExams(sectionId: widget.sectionId);
          }
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: Row(
            children: [
              const AppSidebar(selectedItem: SidebarItem.courses),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header

                      // Header (pill-style like the screenshot)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.r),
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              AppColors.purple.withOpacity(.12),
                              AppColors.purple.withOpacity(.04),
                            ],
                          ),
                          border: Border.all(color: AppColors.darkBlue.withOpacity(.10)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.06),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // العنوان يسار مثل الصورة
                            Text(
                              AppLocalizations.of(context)?.translate("exams") ?? "Exams",
                              style: TextStyle(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w800,
                                color: AppColors.darkBlue,
                                letterSpacing: .2,
                              ),
                            ),

                            // (اختياري) بادجات بسيطة مثل الوقت/اليوم — احذفها إن ما بدك
                            SizedBox(width: 12.w),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(.65),
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border.all(color: AppColors.darkBlue.withOpacity(.06)),
                              ),
                              child: Text(
                                DateFormat('HH:mm').format(DateTime.now()), // مثال
                                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: AppColors.darkBlue),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(.55),
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border.all(color: AppColors.darkBlue.withOpacity(.06)),
                              ),
                              child: Text(
                                DateFormat('EEEE').format(DateTime.now()).toLowerCase(), // مثال
                                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: AppColors.t2),
                              ),
                            ),

                            const Spacer(),

                            // زر على اليمين بشكل كبسولة مع ظل خفيف مثل "Forum" في الصورة
                            ElevatedButton.icon(
                              onPressed: _showCreateExamDialog,
                              icon: Icon(Icons.add, size: 18.sp, color: Colors.white),
                              label: Text(
                                AppLocalizations.of(context)?.translate("create_exam") ?? "Create Exam",
                                style: const TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.darkBlue,
                                elevation: 6,
                                shadowColor: AppColors.darkBlue.withOpacity(.35),
                                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.r), // كبسولة
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),



                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Text(
                      //       AppLocalizations.of(context)?.translate("exams") ?? "Exams",
                      //       style: TextStyle(
                      //         fontSize: 28.sp,
                      //         fontWeight: FontWeight.bold,
                      //         color: AppColors.darkBlue,
                      //       ),
                      //     ),
                      //     ElevatedButton.icon(
                      //       onPressed: _showCreateExamDialog,
                      //       icon: Icon(Icons.add, size: 20.sp),
                      //       label: Text(AppLocalizations.of(context)?.translate("create_exam") ?? "Create Exam"),
                      //       style: ElevatedButton.styleFrom(backgroundColor: AppColors.purple),
                      //     ),
                      //   ],
                      // ),
                      SizedBox(height: 16.h),

                      // Body
                      Expanded(
                        child: BlocBuilder<ExamCubit, ExamState>(
                          builder: (context, state) {
                            if (state is ExamLoading) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            if (state is ExamError) {
                              return Center(child: Text(state.message));
                            }
                            if (state is ExamsLoaded) {
                              final exams = state.page.data;
                              if (exams.isEmpty) {
                                return Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset('assets/Images/no notification.png', width: 200.w, fit: BoxFit.contain),
                                      SizedBox(height: 20.h),
                                      Text(
                                        AppLocalizations.of(context)?.translate("nothing_to_display") ?? 'Nothing to display at this time',
                                        style: TextStyle(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.orange,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }

                              // ======== Grid Cards بدلاً من List ========
                              return LayoutBuilder(
                                builder: (ctx, constraints) {
                                  final w = constraints.maxWidth;
                                  int cross = 4;
                                  if (w < 520) cross = 1;
                                  else if (w < 900) cross = 2;
                                  else if (w < 1200) cross = 3;

                                  return GridView.builder(
                                    padding: EdgeInsets.only(bottom: 8.h),
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: cross,
                                      crossAxisSpacing: 14.w,
                                      mainAxisSpacing: 14.h,
                                      childAspectRatio: 1.15,
                                    ),
                                    itemCount: exams.length,
                                    itemBuilder: (_, i) {
                                      final exam = exams[i];
                                      return _ExamCard(
                                        exam: exam,
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => MarksSection(
                                                exam: exam,
                                                students: widget.students,
                                                trainerId: widget.trainerId,
                                                token: widget.token,
                                              ),
                                            ),
                                          );
                                        },
                                        onEdit: () => _showEditExamDialog(exam),
                                        onDelete: () => _confirmDeleteExam(exam.id),
                                      );
                                    },
                                  );
                                },
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCreateExamDialog() {
    final _nameCtrl = TextEditingController();
    DateTime? _chosenDate;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx2, setDialogState) => AlertDialog(
            title: Text(AppLocalizations.of(context)?.translate("create_exam") ?? "Create Exam"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameCtrl,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)?.translate("exam_name") ?? "Exam Name",
                  ),
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _chosenDate == null
                            ? (AppLocalizations.of(context)?.translate("no_date_chosen") ?? "No date chosen")
                            : DateFormat('yyyy-MM-dd – HH:mm').format(_chosenDate!),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        final d = await showDatePicker(
                          context: ctx2,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (d != null) {
                          final t = await showTimePicker(context: ctx2, initialTime: TimeOfDay.now());
                          if (t != null) {
                            setDialogState(() {
                              _chosenDate = DateTime(d.year, d.month, d.day, t.hour, t.minute);
                            });
                          }
                        }
                      },
                      child: Text(AppLocalizations.of(context)?.translate("pick_date") ?? "Pick Date"),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(AppLocalizations.of(context)?.translate("cancel") ?? "cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  final name = _nameCtrl.text.trim();
                  if (name.isEmpty || _chosenDate == null) return;
                  _examCubit.createExam(
                    name: name,
                    examDate: _chosenDate!,
                    courseSectionId: widget.sectionId,
                  );
                },
                child: Text(AppLocalizations.of(context)?.translate("create") ?? "Create"),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEditExamDialog(ExamModel exam) {
    final _nameCtrl = TextEditingController(text: exam.name);
    DateTime _chosenDate = exam.examDate;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx2, setDialogState) => AlertDialog(
            title: Text(AppLocalizations.of(context)?.translate("edit_exam") ?? "Edit Exam"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameCtrl,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)?.translate("exam_name") ?? "Exam Name",
                  ),
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                      child: Text(DateFormat('yyyy-MM-dd – HH:mm').format(_chosenDate)),
                    ),
                    TextButton(
                      onPressed: () async {
                        final d = await showDatePicker(
                          context: ctx2,
                          initialDate: _chosenDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (d != null) {
                          final t = await showTimePicker(
                            context: ctx2,
                            initialTime: TimeOfDay.fromDateTime(_chosenDate),
                          );
                          if (t != null) {
                            setDialogState(() {
                              _chosenDate = DateTime(d.year, d.month, d.day, t.hour, t.minute);
                            });
                          }
                        }
                      },
                      child: Text(AppLocalizations.of(context)?.translate("pick_date") ?? "Pick Date"),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(AppLocalizations.of(context)?.translate("cancel") ?? "Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  final name = _nameCtrl.text.trim();
                  if (name.isEmpty) return;
                  _examCubit.updateExam(
                    examId: exam.id,
                    name: name,
                    examDate: _chosenDate,
                  );
                },
                child: Text(AppLocalizations.of(context)?.translate("save") ?? "Save"),
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmDeleteExam(int examId) {
    showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(AppLocalizations.of(context)?.translate("delete_exam_q") ?? "Delete Exam?"),
        content: Text(AppLocalizations.of(context)?.translate("delete_exam_confirm") ?? "This will remove the exam permanently."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context)?.translate("no") ?? "No"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(AppLocalizations.of(context)?.translate("yes") ?? "Yes"),
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed == true) {
        _examCubit.deleteExam(examId: examId);
      }
    });
  }
}

class _ExamCard extends StatefulWidget {
  final ExamModel exam;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ExamCard({
    required this.exam,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<_ExamCard> createState() => _ExamCardState();
}

class _ExamCardState extends State<_ExamCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final date = widget.exam.examDate;

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: t.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: AppColors.darkBlue),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_hover ? .08 : .04),
                blurRadius: _hover ? 18 : 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Actions row
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      DateFormat('MMM d').format(date),
                      style: t.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    tooltip: AppLocalizations.of(context)?.translate("edit_exam") ?? "Edit exam",
                    onPressed: widget.onEdit,
                    icon: Icon(Icons.edit_outlined, color: AppColors.orange),
                    visualDensity: VisualDensity.compact,
                  ),
                  IconButton(
                    tooltip: AppLocalizations.of(context)?.translate("delete") ?? "Delete",
                    onPressed: widget.onDelete,
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
              SizedBox(height: 8.h),

              // Title

              Text(
                widget.exam.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: t.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.darkBlue,
                  letterSpacing: .2,
                ),
              ),
              SizedBox(height: 8.h),

              // Date row
              Row(
                children: [
                  Icon(Icons.event, size: 18.sp, color: t.colorScheme.onSurfaceVariant),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: Text(
                      DateFormat('yyyy-MM-dd – HH:mm').format(date),
                      style: t.textTheme.bodySmall?.copyWith(color: t.colorScheme.onSurfaceVariant),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // CTA
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.darkBlue,
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                  ),
                  onPressed: widget.onTap,
                  icon: const Icon(Icons.checklist_outlined, size: 18, color: Colors.white),
                  label: Text(
                    AppLocalizations.of(context)?.translate("manage_marks") ?? "Manage marks",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
