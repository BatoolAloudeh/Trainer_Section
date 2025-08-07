// lib/screen/Home/Courses/AddExamsAndMarks/Marks&Exams.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_network/image_network.dart';

import '../../../../Bloc/cubit/Grades/Grade.dart';
import '../../../../Bloc/states/Grades/Grade.dart';
import '../../../../constant/constantKey/key.dart';
import '../../../../constant/ui/Colors/colors.dart';
import '../../../../constant/ui/General constant/ConstantUi.dart';
import '../../../../models/Exams/Exam.dart';
import '../../../../models/Grades/Grades.dart';
import 'package:intl/intl.dart';



class MarksSection extends StatefulWidget {
  final ExamModel exam;
  final List<Map<String, String>> students;
  final int trainerId;
  final String token;

  const MarksSection({
    Key? key,
    required this.exam,
    required this.students,
    required this.trainerId,
    required this.token,
  }) : super(key: key);

  @override
  State<MarksSection> createState() => _MarksSectionState();
}

class _MarksSectionState extends State<MarksSection> {
  late GradeCubit _gradeCubit;
  final Map<int, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    _gradeCubit = GradeCubit()
      ..fetchGrades(
          // token: widget.token,
          examId: widget.exam.id);
  }

  @override
  void dispose() {
    _gradeCubit.close();
    _controllers.values.forEach((c) => c.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: const Size(1440, 1024), minTextAdapt: true);

    return BlocProvider.value(
      value: _gradeCubit,
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

                    Text(widget.exam.name,
                        style: TextStyle(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkBlue)),
                    SizedBox(height: 8.h),
                    Text(
                        DateFormat('yyyy-MM-dd – HH:mm')
                            .format(widget.exam.examDate),
                        style:
                        TextStyle(fontSize: 16.sp, color: AppColors.t2)),
                    SizedBox(height: 24.h),


                    Expanded(
                      child: BlocListener<GradeCubit, GradeState>(
                        listener: (ctx, state) {
                          if (state is GradeCreated ||
                              state is GradeUpdated ||
                              state is GradeDeleted) {
                            ctx.read<GradeCubit>().fetchGrades(
                                // token: widget.token,
                                examId: widget.exam.id);
                          }
                        },
                        child: BlocBuilder<GradeCubit, GradeState>(
                          builder: (ctx, state) {
                            if (state is GradeLoading) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            if (state is GradeError) {
                              return Center(child: Text(state.message));
                            }

                            final existing = <int, GradeModel>{};
                            if (state is GradesLoaded) {
                              for (var g in state.page.data) {
                                existing[g.studentId] = g;
                                _controllers.putIfAbsent(
                                    g.studentId,
                                        () => TextEditingController(
                                        text: g.grade.toString()));
                              }
                            }

                            return ListView.separated(
                              itemCount: widget.students.length,
                              separatorBuilder: (_, __) =>
                                  SizedBox(height: 12.h),
                              itemBuilder: (_, i) {
                                final s = widget.students[i];
                                final sid = int.parse(s['id']!);
                                final name = s['name']!;
                                final cls = s['class']!;
                                final ctrl = _controllers.putIfAbsent(
                                    sid, () => TextEditingController());
                                final hasGrade = existing.containsKey(sid);
                                String photoUrl = s['photo'] != null
                                    ? "$BASE_URL${s['photo']}"
                                    : "";
                                return Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(12.r)),
                                  child: ListTile(
                                    leading:
                                    CircleAvatar(
                                      radius: 20,
                                      child:
                                      ClipOval(
                                        child: s['photo']!  != null
                                            ? ImageNetwork(
                                          image: photoUrl,
                                          width: 40,
                                          height: 40,
                                          fitAndroidIos: BoxFit.cover,
                                        )
                                            : Icon(Icons.person, size: 20),
                                      ),),
                                    title: Text(name,
                                        style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight:
                                            FontWeight.bold)),
                                    subtitle: Text(cls,
                                        style: TextStyle(
                                            color: AppColors.t2)),
                                    trailing: SizedBox(
                                      width: 160.w,
                                      child: Row(
                                        children: [

                                          Expanded(
                                            child: TextField(
                                              controller: ctrl,
                                              keyboardType:
                                              TextInputType.number,
                                              decoration: InputDecoration(
                                                hintText: 'Grade',
                                                isDense: true,
                                                contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 8.h,
                                                    horizontal: 8.w),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      8.r),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 4.w),

                                          // زر حفظ (إنشاء/تحديث)
                                          GestureDetector(
                                            onTap: () {
                                              final text =
                                              ctrl.text.trim();
                                              if (text.isEmpty) return;
                                              final val =
                                              double.tryParse(text);
                                              if (val == null) return;
                                              if (hasGrade) {
                                                ctx
                                                    .read<
                                                    GradeCubit>()
                                                    .updateGrade(
                                                  // token: widget.token,
                                                  gradeId:
                                                  existing[
                                                  sid]!
                                                      .id,
                                                  grade: val,
                                                );
                                              } else {
                                                ctx
                                                    .read<
                                                    GradeCubit>()
                                                    .createGrade(
                                                  // token: widget.token,
                                                  studentId: sid,
                                                  examId: widget
                                                      .exam.id,
                                                  grade: val,
                                                );
                                              }
                                            },
                                            child: Icon(Icons.save,
                                                size: 24.sp,
                                                color:
                                                AppColors.orange),
                                          ),

                                          if (hasGrade) ...[
                                            SizedBox(width: 8.w),
                                            GestureDetector(
                                              onTap: () {
                                                ctx
                                                    .read<
                                                    GradeCubit>()
                                                    .deleteGrade(
                                                  // token: widget.token,
                                                  gradeId:
                                                  existing[
                                                  sid]!
                                                      .id,
                                                );
                                              },
                                              child: Icon(Icons.delete,
                                                  size: 24.sp,
                                                  color: Colors.red),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
