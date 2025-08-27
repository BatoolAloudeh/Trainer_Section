
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:trainer_section/screen/Home/Courses/Attendance/AttendancePage.dart';

import '../../../../Bloc/cubit/sessions/session.dart';
import '../../../../Bloc/states/sessions/session.dart';
import '../../../../constant/ui/Colors/colors.dart';
import '../../../../constant/ui/General constant/ConstantUi.dart';
import '../../../../localization/app_localizations.dart';
import '../../../../models/sessions/session.dart';

class SessionsPage extends StatefulWidget {
  final List<Map<String, String>> students;
  final int sectionId;
  final int trainerId;
  final String token;

  const SessionsPage({
    Key? key,
    required this.students,
    required this.sectionId,
    required this.trainerId,
    required this.token,
  }) : super(key: key);

  @override
  State<SessionsPage> createState() => _SessionsPageState();
}

class _SessionsPageState extends State<SessionsPage> {
  late SessionCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = SessionCubit()..fetchSessions(sectionId: widget.sectionId);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(1440, 1024), minTextAdapt: true);

    return BlocProvider.value(
      value: _cubit,
      child: BlocListener<SessionCubit, SessionState>(
        listener: (ctx, state) {
          if (state is SessionCreated || state is SessionUpdated) {
            WidgetsBinding.instance.addPostFrameCallback((_) => Navigator.of(context).pop());
            _cubit.fetchSessions(sectionId: widget.sectionId);
          }
          if (state is SessionDeleted) {
            _cubit.fetchSessions(sectionId: widget.sectionId);
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
                      // ===== Header (pill-style مثل صفحة الاختبارات) =====
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
                            Text(
                              AppLocalizations.of(context)?.translate("sessions") ?? "Sessions",
                              style: TextStyle(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w800,
                                color: AppColors.darkBlue,
                                letterSpacing: .2,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            // بادج الوقت (اختياري — نفس نمط الاختبارات)
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(.65),
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border.all(color: AppColors.darkBlue.withOpacity(.06)),
                              ),
                              child: Text(
                                DateFormat('HH:mm').format(DateTime.now()),
                                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: AppColors.darkBlue),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            // بادج اليوم (اختياري)
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(.55),
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border.all(color: AppColors.darkBlue.withOpacity(.06)),
                              ),
                              child: Text(
                                DateFormat('EEEE').format(DateTime.now()).toLowerCase(),
                                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: AppColors.t2),
                              ),
                            ),
                            const Spacer(),
                            // زر إنشاء سيشن بنفس زر Create Exam
                            ElevatedButton.icon(
                              onPressed: _showCreateDialog,
                              icon: Icon(Icons.add, size: 18.sp, color: Colors.white),
                              label: Text(
                                AppLocalizations.of(context)?.translate("create_session") ?? "Create Session",
                                style: const TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.darkBlue,
                                elevation: 6,
                                shadowColor: AppColors.darkBlue.withOpacity(.35),
                                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // ===== Body: Grid Cards بنفس منطق الاختبارات =====
                      Expanded(
                        child: BlocBuilder<SessionCubit, SessionState>(
                          builder: (ctx, state) {
                            if (state is SessionLoading) {
                              return const _LoadingState();
                            }
                            if (state is SessionError) {
                              return _ErrorState(message: state.message);
                            }
                            if (state is SessionsLoaded) {
                              final list = state.page.data;
                              if (list.isEmpty) {
                                return const _EmptyState();
                              }

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
                                    itemCount: list.length,
                                    itemBuilder: (_, i) {
                                      final s = list[i];
                                      return _SessionCard(
                                        session: s,
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => AttendancePage(
                                                students: widget.students,
                                                token: widget.token,
                                                sessionId: s.id,
                                                sessionName: s.name,
                                              ),
                                            ),
                                          );
                                        },
                                        onEdit: () => _showEditDialog(s),
                                        onDelete: () => _confirmDelete(s.id),
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

  void _showCreateDialog() {
    final nameCtrl = TextEditingController();
    DateTime? picked;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(context)?.translate("create_session") ?? "Create Session"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)?.translate("name") ?? "Name",
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: Text(
                    picked == null
                        ? (AppLocalizations.of(context)?.translate("no_date_chosen") ?? "No date chosen")
                        : DateFormat('yyyy-MM-dd – HH:mm').format(picked!),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    final d = await showDatePicker(
                      context: ctx,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );
                    if (d != null) {
                      final t = await showTimePicker(context: ctx, initialTime: TimeOfDay.now());
                      if (t != null) {
                        setState(() => picked = DateTime(d.year, d.month, d.day, t.hour, t.minute));
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
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(AppLocalizations.of(context)?.translate("cancel") ?? "Cancel")),
          ElevatedButton(
            onPressed: () {
              final name = nameCtrl.text.trim();
              if (name.isEmpty || picked == null) return;
              _cubit.createSession(
                name: name,
                sessionDate: picked!,
                courseSectionId: widget.sectionId,
              );
            },
            child: Text(AppLocalizations.of(context)?.translate("create") ?? "Create"),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(SessionModel s) {
    final nameCtrl = TextEditingController(text: s.name);
    DateTime picked = s.sessionDate;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(context)?.translate("edit_session") ?? "Edit Session"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)?.translate("name") ?? "Name",
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(child: Text(DateFormat('yyyy-MM-dd – HH:mm').format(picked))),
                TextButton(
                  onPressed: () async {
                    final d = await showDatePicker(
                      context: ctx,
                      initialDate: picked,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );
                    if (d != null) {
                      final t = await showTimePicker(
                        context: ctx,
                        initialTime: TimeOfDay.fromDateTime(picked),
                      );
                      if (t != null) {
                        setState(() => picked = DateTime(d.year, d.month, d.day, t.hour, t.minute));
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
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(AppLocalizations.of(context)?.translate("cancel") ?? "Cancel")),
          ElevatedButton(
            onPressed: () {
              final name = nameCtrl.text.trim();
              if (name.isEmpty) return;
              _cubit.updateSession(
                sessionId: s.id,
                name: name,
                sessionDate: picked,
              );
            },
            child: Text(AppLocalizations.of(context)?.translate("save") ?? "Save"),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(int id) {
    showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(AppLocalizations.of(context)?.translate("delete_session_q") ?? "Delete Session?"),
        content: const SizedBox.shrink(),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(AppLocalizations.of(context)?.translate("no") ?? "No")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text(AppLocalizations.of(context)?.translate("yes") ?? "Yes")),
        ],
      ),
    ).then((yes) {
      if (yes == true) {
        _cubit.deleteSession(sessionId: id);
      }
    });
  }
}

// =================== Cards (نفس ستايل الاختبارات) ===================

class _SessionCard extends StatefulWidget {
  final SessionModel session;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _SessionCard({
    required this.session,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<_SessionCard> createState() => _SessionCardState();
}

class _SessionCardState extends State<_SessionCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final date = widget.session.sessionDate;

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
            border: Border.all(color: AppColors.darkBlue), // مثل _ExamCard
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
              // شارة تاريخ + أزرار
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
                    tooltip: AppLocalizations.of(context)?.translate("edit_session") ?? "Edit Session",
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

              // العنوان
              Text(
                widget.session.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: t.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.darkBlue,
                  letterSpacing: .2,
                ),
              ),
              SizedBox(height: 8.h),

              // التاريخ والوقت
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

              // CTA (Attendance)
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.darkBlue,
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                  ),
                  onPressed: widget.onTap,
                  icon: const Icon(Icons.fact_check_outlined, size: 18, color: Colors.white),
                  label: Text(
                    AppLocalizations.of(context)?.translate("attendance") ?? "Attendance",
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

// ========= حالات الواجهة / حوارات مساعدة =========

class _EmptyState extends StatelessWidget {
  const _EmptyState();
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/Images/no notification.png',
            width: 200.w,
            fit: BoxFit.contain,
          ),

          Text(
            AppLocalizations.of(context)?.translate("nothing_to_display") ?? 'Nothing to display at this time',
            style: TextStyle(
              fontSize: 18.sp,
              color: AppColors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),

        ],
      ),
    );
  }
}

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
