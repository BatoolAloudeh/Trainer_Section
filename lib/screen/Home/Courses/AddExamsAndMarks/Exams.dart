

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:trainer_section/screen/Home/Courses/AddExamsAndMarks/Marks.dart';

import '../../../../Bloc/cubit/Exams/Exam.dart';
import '../../../../Bloc/states/Exams/Exam.dart';
import '../../../../constant/ui/Colors/colors.dart';
import '../../../../constant/ui/General constant/ConstantUi.dart';
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
    _examCubit = ExamCubit()
      ..fetchExams(
          // token: widget.token,
          sectionId: widget.sectionId);
  }

  @override
  void dispose() {
    _examCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: const Size(1440, 1024), minTextAdapt: true);

    return BlocProvider.value(
      value: _examCubit,
      child: BlocListener<ExamCubit, ExamState>(
        listener: (ctx, state) {
          if (state is ExamCreated || state is ExamUpdated) {

            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pop();
            });
            _examCubit.fetchExams(
              // token: widget.token,
              sectionId: widget.sectionId,
            );
          }
          if (state is ExamDeleted) {
            _examCubit.fetchExams(
              // token: widget.token,
              sectionId: widget.sectionId,
            );
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

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Exams',
                              style: TextStyle(
                                  fontSize: 28.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.darkBlue)),
                          ElevatedButton.icon(
                            onPressed: _showCreateExamDialog,
                            icon: Icon(Icons.add, size: 20.sp),
                            label: Text('Create Exam'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.purple,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),

                      Expanded(
                        child: BlocBuilder<ExamCubit, ExamState>(
                          builder: (context, state) {
                            if (state is ExamLoading) {
                              return const Center(
                                  child: CircularProgressIndicator());
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
                                      Image.asset(
                                        'assets/Images/no notification.png',
                                        width: 200.w,
                                        fit: BoxFit.contain,
                                      ),
                                      SizedBox(height: 20.h),
                                      Text(
                                        'No Exams Yet',
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
                              return ListView.separated(
                                itemCount: exams.length,
                                separatorBuilder: (_, __) =>
                                    SizedBox(height: 12.h),
                                itemBuilder: (_, i) {
                                  final exam = exams[i];
                                  return Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    child: ListTile(
                                      title: Text(
                                        exam.name,
                                        style: TextStyle(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(
                                        DateFormat('yyyy-MM-dd – HH:mm')
                                            .format(exam.examDate),
                                        style: TextStyle(color: AppColors.t2),
                                      ),
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
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.edit,
                                                color: AppColors.orange),
                                            onPressed: () =>
                                                _showEditExamDialog(exam),
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.delete,
                                                color: Colors.red),
                                            onPressed: () =>
                                                _confirmDeleteExam(exam.id),
                                          ),
                                        ],
                                      ),
                                    ),
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
            title: Text('Create Exam'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameCtrl,
                  decoration: InputDecoration(labelText: 'Exam Name'),
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _chosenDate == null
                            ? 'No date chosen'
                            : DateFormat('yyyy-MM-dd – HH:mm')
                            .format(_chosenDate!),
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
                          final t = await showTimePicker(
                              context: ctx2,
                              initialTime: TimeOfDay.now());
                          if (t != null) {
                            setDialogState(() {
                              _chosenDate = DateTime(
                                  d.year, d.month, d.day, t.hour, t.minute);
                            });
                          }
                        }
                      },
                      child: Text('Pick Date'),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel')),
              ElevatedButton(
                onPressed: () {
                  final name = _nameCtrl.text.trim();
                  if (name.isEmpty || _chosenDate == null) return;
                  _examCubit.createExam(
                    // token: widget.token,
                    name: name,
                    examDate: _chosenDate!,
                    courseSectionId: widget.sectionId,
                  );
                },
                child: Text('Create'),
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
            title: Text('Edit Exam'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameCtrl,
                  decoration: InputDecoration(labelText: 'Exam Name'),
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                        child: Text(DateFormat('yyyy-MM-dd – HH:mm')
                            .format(_chosenDate))),
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
                              initialTime:
                              TimeOfDay.fromDateTime(_chosenDate));
                          if (t != null) {
                            setDialogState(() {
                              _chosenDate = DateTime(
                                  d.year, d.month, d.day, t.hour, t.minute);
                            });
                          }
                        }
                      },
                      child: Text('Pick Date'),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel')),
              ElevatedButton(
                onPressed: () {
                  final name = _nameCtrl.text.trim();
                  if (name.isEmpty) return;
                  _examCubit.updateExam(
                    // token: widget.token,
                    examId: exam.id,
                    name: name,
                    examDate: _chosenDate,
                  );
                },
                child: Text('Save'),
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
        title: Text('Delete Exam?'),
        content: Text('This will remove the exam permanently.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('No')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Yes')),
        ],
      ),
    ).then((confirmed) {
      if (confirmed == true) {
        _examCubit.deleteExam(
            // token: widget.token,
            examId: examId);
      }
    });
  }
}
