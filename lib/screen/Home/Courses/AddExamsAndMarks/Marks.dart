
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_network/image_network.dart';
import 'package:intl/intl.dart';

import '../../../../Bloc/cubit/Grades/Grade.dart';
import '../../../../Bloc/states/Grades/Grade.dart';
import '../../../../constant/constantKey/key.dart';
import '../../../../constant/ui/Colors/colors.dart';
import '../../../../constant/ui/General constant/ConstantUi.dart';
import '../../../../localization/app_localizations.dart';
import '../../../../models/Exams/Exam.dart';
import '../../../../models/Grades/Grades.dart';

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
    _gradeCubit = GradeCubit()..fetchGrades(examId: widget.exam.id);
  }

  @override
  void dispose() {
    _gradeCubit.close();
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(1440, 1024), minTextAdapt: true);
    final t = Theme.of(context);

    return BlocProvider.value(
      value: _gradeCubit,
      child: Scaffold(
        backgroundColor: t.colorScheme.surface,
        body: Row(
          children: [
            const AppSidebar(selectedItem: SidebarItem.courses),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      t.colorScheme.surface,
                      t.colorScheme.surfaceContainerHighest.withOpacity(.35),
                    ],
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // نُبقي الهيدر كما هو (نفس ستايل الاختبارات/السيشنز)
                      _HeaderBar(
                        title: widget.exam.name,
                        dateText: DateFormat('yyyy-MM-dd – HH:mm').format(widget.exam.examDate),
                        rightLabel:
                        '${AppLocalizations.of(context)?.translate("students") ?? "Students"}: ${widget.students.length}',
                      ),
                      SizedBox(height: 16.h),

                      Expanded(
                        child: BlocListener<GradeCubit, GradeState>(
                          listener: (ctx, state) {
                            if (state is GradeCreated || state is GradeUpdated || state is GradeDeleted) {
                              ctx.read<GradeCubit>().fetchGrades(examId: widget.exam.id);
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.all(16.w),
                            child: BlocBuilder<GradeCubit, GradeState>(
                              builder: (ctx, state) {
                                if (state is GradeLoading) return const _LoadingState();
                                if (state is GradeError)   return _ErrorState(message: state.message);

                                final existing = <int, GradeModel>{};
                                if (state is GradesLoaded) {
                                  for (final g in state.page.data) {
                                    existing[g.studentId] = g;
                                    _controllers.putIfAbsent(
                                      g.studentId, () => TextEditingController(text: g.grade.toString()),
                                    );
                                  }
                                }

                                if (widget.students.isEmpty) return const _EmptyState();

                                return ScrollConfiguration(
                                  behavior: const MaterialScrollBehavior().copyWith(overscroll: false),
                                  child: ListView.separated(
                                    padding: EdgeInsets.only(bottom: 24.h), // لتفادي أي overflow سفلي
                                    itemCount: widget.students.length,
                                    separatorBuilder: (_, __) => SizedBox(height: 10.h),
                                    itemBuilder: (_, i) {
                                      final s   = widget.students[i];
                                      final sid = int.tryParse(s['id'] ?? '') ?? 0;
                                      final name = s['name'] ?? '-';
                                      final cls  = s['class'] ?? '';
                                      final ctrl = _controllers.putIfAbsent(sid, () => TextEditingController());
                                      final hasGrade  = existing.containsKey(sid);
                                      final photoPath = s['photo'] ?? '';
                                      final photoUrl  = photoPath.isNotEmpty ? "$BASE_URL$photoPath" : '';

                                      return _ReportRowStyle(
                                        index: i,
                                        avatarUrl: photoUrl,
                                        title: name,
                                        subtitle: cls,
                                        dateText: DateFormat('yyyy-MM-dd').format(widget.exam.examDate),
                                        controller: ctrl,
                                        hasGrade: hasGrade,
                                        onSave: () {
                                          final val = double.tryParse(ctrl.text.trim());
                                          if (val == null) return;
                                          if (hasGrade) {
                                            ctx.read<GradeCubit>().updateGrade(gradeId: existing[sid]!.id, grade: val);
                                          } else {
                                            ctx.read<GradeCubit>().createGrade(studentId: sid, examId: widget.exam.id, grade: val);
                                          }
                                        },
                                        onDelete: hasGrade ? () => ctx.read<GradeCubit>().deleteGrade(gradeId: existing[sid]!.id) : null,
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ------------------ Header (نفسه) ------------------
class _HeaderBar extends StatelessWidget {
  final String title;
  final String dateText;
  final String rightLabel;

  const _HeaderBar({
    required this.title,
    required this.dateText,
    required this.rightLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Expanded(
            child: Row(
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.darkBlue,
                    letterSpacing: .2,
                  ),
                ),
                SizedBox(width: 12.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.65),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: AppColors.darkBlue.withOpacity(.06)),
                  ),
                  child: Text(
                    dateText,
                    style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: AppColors.darkBlue),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.55),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: AppColors.darkBlue.withOpacity(.06)),
            ),
            child: Text(
              rightLabel,
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: AppColors.t2),
            ),
          ),
        ],
      ),
    );
  }
}

/// ------------------ Reports-like Row ------------------
class _ReportRowStyle extends StatelessWidget {
  final int index;
  final String avatarUrl;
  final String title;
  final String subtitle;
  final String dateText;
  final TextEditingController controller;
  final VoidCallback onSave;
  final VoidCallback? onDelete;
  final bool hasGrade;

  const _ReportRowStyle({
    required this.index,
    required this.avatarUrl,
    required this.title,
    required this.subtitle,
    required this.dateText,
    required this.controller,
    required this.onSave,
    required this.onDelete,
    required this.hasGrade,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final loc = AppLocalizations.of(context);

    final stripe = AppColors.purple.withOpacity(.06);
    final bg = index.isEven ? stripe : Colors.transparent;

    return Container(
      // لا ارتفاع ثابت لتفادي overflow
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // صورة
          CircleAvatar(
            radius: 18.r,
            backgroundColor: t.colorScheme.primary.withOpacity(.12),
            child: ClipOval(
              child: avatarUrl.isNotEmpty
                  ? ImageNetwork(image: avatarUrl, width: 36.r, height: 36.r, fitAndroidIos: BoxFit.cover)
                  : Icon(Icons.person, size: 18.sp, color: t.colorScheme.primary),
            ),
          ),
          SizedBox(width: 10.w),

          // الاسم + الصف
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 260.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: t.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700, color: AppColors.darkBlue),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: t.textTheme.bodySmall?.copyWith(color: t.colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),

          // حقل العلامة
          SizedBox(width: 16.w),
          Expanded(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 280.w),
              child: TextField(
                controller: controller,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => onSave(),
                decoration: InputDecoration(
                  hintText: loc?.translate("grade") ?? "Grade",
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
                  filled: true,
                  fillColor: t.colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide(color: t.colorScheme.outlineVariant),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide(color: t.colorScheme.outlineVariant),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide(color: t.colorScheme.primary, width: 1.6),
                  ),
                ),
              ),
            ),
          ),

          // التاريخ
          SizedBox(width: 16.w),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 120.w),
            child: Text(
              dateText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style: t.textTheme.bodySmall?.copyWith(color: t.colorScheme.onSurfaceVariant),
            ),
          ),

          // أزرار أيقونات فقط (بدون دوائر)
          SizedBox(width: 8.w),
          Tooltip(
            message: loc?.translate("save") ?? "Save",
            child: IconButton(
              onPressed: onSave,
              icon: const Icon(Icons.save_alt_rounded),
              color: AppColors.orange,
              splashRadius: 22,
            ),
          ),
          if (onDelete != null)
            Tooltip(
              message: loc?.translate("delete") ?? "Delete",
              child: IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_forever_rounded),
                color: Colors.redAccent,
                splashRadius: 22,
              ),
            ),
        ],
      ),
    );
  }
}


class _RoundIconButton extends StatelessWidget {
  final String tooltip;
  final IconData icon;
  final Color bg;
  final VoidCallback onTap;

  const _RoundIconButton({
    required this.tooltip,
    required this.icon,
    required this.bg,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          height: 36.r,
          width: 36.r,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.15),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: const Icon(Icons.arrow_right, color: Colors.transparent), // للحجم فقط
        ),
      ),
    );
  }
}

/// نستبدل الأيقونة الفعلية فوق (حتى لا يتغيّر الحجم)
extension on _RoundIconButton {
  Widget get _icon => Icon(icon, color: Colors.white, size: 18);
}

/// ------------------ States ------------------
class _LoadingState extends StatelessWidget {
  const _LoadingState();
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          SizedBox(height: 12.h),
          Text(loc?.translate("loading") ?? "Loading..."),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  const _ErrorState({required this.message});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 42.sp, color: Colors.redAccent),
          SizedBox(height: 8.h),
          Text(message, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.group_off, size: 56.sp, color: Theme.of(context).colorScheme.onSurfaceVariant),
          SizedBox(height: 8.h),
          Text(loc?.translate("no_students") ?? "No students available"),
        ],
      ),
    );
  }
}
