// lib/screens/sessions/AttendancePage.dart  (refined like Marks page – same tasks)

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_network/image_network.dart';

import '../../../../Bloc/cubit/Attendence/attendence.dart';
import '../../../../Bloc/states/Attendence/attendence.dart';
import '../../../../constant/constantKey/key.dart';
import '../../../../constant/ui/Colors/colors.dart';
import '../../../../localization/app_localizations.dart';
import '../../../../models/Attendence/attendence.dart';
import '../../../../constant/ui/General constant/ConstantUi.dart';

class AttendancePage extends StatefulWidget {
  final int sessionId;
  final String token;
  final List<Map<String, String>> students;
  final String sessionName;

  const AttendancePage({
    Key? key,
    required this.sessionId,
    required this.token,
    required this.students,
    required this.sessionName,
  }) : super(key: key);

  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  late AttendanceCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = AttendanceCubit()..fetchAttendance(sessionId: widget.sessionId);
  }
  String _resolveHeaderTitle(BuildContext context, String sessionName) {
    // نص الترجمة قد يحتوي على {session}
    final raw = AppLocalizations.of(context)?.translate("attendance_for_session")
        ?? 'Attendance for "{session}"';
    if (raw.contains('{session}')) {
      // يستبدل placeholder ويمنع ظهور {session} حرفيًا
      return raw.replaceAll('{session}', sessionName);
    }
    // لو الترجمة ما فيها placeholder نضيف الاسم يدويًا (اختر بدون علامات اقتباس)
    return '$raw $sessionName';
  }


  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(1440, 1024), minTextAdapt: true);
    final t = Theme.of(context);

    return BlocProvider.value(
      value: _cubit,
      child: BlocListener<AttendanceCubit, AttendanceState>(
        listener: (ctx, state) {
          if (state is AttendanceMarked || state is AttendanceUpdated || state is AttendanceDeleted) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ctx.read<AttendanceCubit>().fetchAttendance(sessionId: widget.sessionId);
            });
          }
        },
        child: Scaffold(
          backgroundColor: t.scaffoldBackgroundColor,
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
                        t.scaffoldBackgroundColor,
                        t.colorScheme.surfaceVariant.withOpacity(.25),
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(24.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _HeaderBar(
                          title: _resolveHeaderTitle(context, widget.sessionName),
                          rightLabel: '${AppLocalizations.of(context)?.translate("students") ?? "Students"}: ${widget.students.length}',
                        ),

                        SizedBox(height: 40.h),

                        Expanded(
                          child: BlocBuilder<AttendanceCubit, AttendanceState>(
                            builder: (ctx, state) {
                              if (state is AttendanceLoading) return const _LoadingState();
                              if (state is AttendanceError) return _ErrorState(message: state.message);

                              // خرائط للحضور الحالي لسرعة الوصول
                              final Map<int, AttendanceModel> recordsByStudent = {};
                              if (state is AttendanceLoaded) {
                                for (final r in state.list) {
                                  recordsByStudent[r.studentId] = r;
                                }
                              }

                              if (widget.students.isEmpty) {
                                return Center(
                                  child: SingleChildScrollView(
                                    padding: EdgeInsets.symmetric(vertical: 16.h),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.group_off,
                                            size: 56.sp, color: t.colorScheme.onSurfaceVariant),
                                        SizedBox(height: 8.h),
                                        Text(AppLocalizations.of(context)?.translate("no_students") ??
                                            "No students"),
                                      ],
                                    ),
                                  ),
                                );
                              }

                              // نفس ستايل "Marks" — صفوف مخططة بلا Card
                              return ScrollConfiguration(
                                behavior: const MaterialScrollBehavior().copyWith(overscroll: false),
                                child: ListView.separated(
                                  padding: EdgeInsets.only(bottom: 24.h),
                                  itemCount: widget.students.length,
                                  separatorBuilder: (_, __) => SizedBox(height: 10.h),
                                  itemBuilder: (_, idx) {
                                    final s = widget.students[idx];
                                    final sid = int.tryParse(s['id'] ?? '') ?? 0;

                                    final rec = recordsByStudent[sid];
                                    // ملاحظة: للحفاظ على نفس المنطق القديم، إذا لا يوجد سجل نترك الأيقونات غير مفعلة
                                    final hasRecord = rec != null;
                                    final isPresent = rec?.isPresent ?? false;

                                    final photoPath = s['photo'];
                                    final photoUrl =
                                    (photoPath != null && photoPath.isNotEmpty) ? "$BASE_URL$photoPath" : '';

                                    return _AttendanceRowStyle(
                                      index: idx,
                                      avatarUrl: photoUrl,
                                      name: s['name'] ?? '-',
                                      className: s['class'] ?? '-',
                                      hasRecord: hasRecord,
                                      isPresent: isPresent,
                                      onMarkPresent: () {
                                        if (rec == null) {
                                          _cubit.markAttendance(
                                            sessionId: widget.sessionId,
                                            studentId: sid,
                                            isPresent: true,
                                          );
                                        } else {
                                          _cubit.updateAttendance(attendanceId: rec.id, isPresent: true);
                                        }
                                      },
                                      onMarkAbsent: () {
                                        if (rec == null) {
                                          _cubit.markAttendance(
                                            sessionId: widget.sessionId,
                                            studentId: sid,
                                            isPresent: false,
                                          );
                                        } else {
                                          _cubit.updateAttendance(attendanceId: rec.id, isPresent: false);
                                        }
                                      },
                                    );
                                  },
                                ),
                              );
                            },
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
      ),
    );
  }
}

/// ============= Header (نفس ستايل الحبة/الكبسولة المستخدمة) =============
class _HeaderBar extends StatelessWidget {
  final String title;
  final String rightLabel;

  const _HeaderBar({required this.title, required this.rightLabel});

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
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.darkBlue,
                letterSpacing: .2,
              ),
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

/// ============= صفّ طالب بطريقة التقارير (بدون Card/إطار) =============
class _AttendanceRowStyle extends StatelessWidget {
  final int index;
  final String avatarUrl;
  final String name;
  final String className;
  final bool hasRecord; // هل لديه سجل حضور؟
  final bool isPresent; // إذا كان لديه سجل: حاضر أم غائب؟
  final VoidCallback onMarkPresent;
  final VoidCallback onMarkAbsent;

  const _AttendanceRowStyle({
    required this.index,
    required this.avatarUrl,
    required this.name,
    required this.className,
    required this.hasRecord,
    required this.isPresent,
    required this.onMarkPresent,
    required this.onMarkAbsent,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final loc = AppLocalizations.of(context);

    final stripe = AppColors.purple.withOpacity(.06);
    final bg = index.isEven ? stripe : Colors.transparent;

    // ألوان الأيقونات: إن كان هناك سجل، فعّل اللون البرتقالي على الحالة المختارة
    final presentColor = hasRecord
        ? (isPresent ? AppColors.orange : t.colorScheme.onSurfaceVariant)
        : t.colorScheme.onSurfaceVariant;
    final absentColor = hasRecord
        ? (!isPresent ? AppColors.orange : t.colorScheme.onSurfaceVariant)
        : t.colorScheme.onSurfaceVariant;

    return Container(
      constraints: BoxConstraints(minHeight: 56.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar
          CircleAvatar(
            radius: 18.r,
            backgroundColor: t.colorScheme.primary.withOpacity(.12),
            child: ClipOval(
              child: avatarUrl.isNotEmpty
                  ? ImageNetwork(
                image: avatarUrl,
                width: 36.r,
                height: 36.r,
                fitAndroidIos: BoxFit.cover,
              )
                  : Icon(Icons.person, size: 18.sp, color: t.colorScheme.primary),
            ),
          ),
          SizedBox(width: 10.w),

          // الاسم + الصف
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 320.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: t.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkBlue,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  className,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: t.textTheme.bodySmall?.copyWith(
                    color: t.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          // أزرار الحالة (أيقونات مخصّصة بدون دوائر)
          Tooltip(
            message: loc?.translate("present") ?? "Present",
            child: IconButton(
              onPressed: onMarkPresent,
              icon: const Icon(Icons.check_circle_rounded),
              color: presentColor,
              splashRadius: 18,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              visualDensity: const VisualDensity(horizontal: -3, vertical: -3),
            ),
          ),
          SizedBox(width: 8.w),
          Tooltip(
            message: loc?.translate("absent") ?? "Absent",
            child: IconButton(
              onPressed: onMarkAbsent,
              icon: const Icon(Icons.cancel_rounded),
              color: absentColor,
              splashRadius: 18,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              visualDensity: const VisualDensity(horizontal: -3, vertical: -3),
            ),
          ),
        ],
      ),
    );
  }
}

/// ============= States =============
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
