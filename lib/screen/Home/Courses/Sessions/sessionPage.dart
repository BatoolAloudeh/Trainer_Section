// lib/screens/sessions/SessionsPage.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:trainer_section/screen/Home/Courses/Attendance/AttendancePage.dart';

import '../../../../Bloc/cubit/sessions/session.dart';
import '../../../../Bloc/states/sessions/session.dart';
import '../../../../constant/ui/Colors/colors.dart';
import '../../../../constant/ui/General constant/ConstantUi.dart';
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
    _cubit = SessionCubit()
      ..fetchSessions(
          // token: widget.token,
          sectionId: widget.sectionId);
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

            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pop();
            });
            _cubit.fetchSessions(
                // token: widget.token,
                sectionId: widget.sectionId);
          }
          if (state is SessionDeleted) {
            _cubit.fetchSessions(
                // token: widget.token,
                sectionId: widget.sectionId);
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
                          Text(
                            'Sessions',
                            style: TextStyle(
                              fontSize: 28.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkBlue,
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: _showCreateDialog,
                            icon: Icon(Icons.add, size: 20.sp),
                            label: Text('Create Session'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.purple,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),


                      Expanded(
                        child: BlocBuilder<SessionCubit, SessionState>(
                          builder: (ctx, state) {
                            if (state is SessionLoading) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            if (state is SessionError) {
                              return Center(child: Text(state.message));
                            }
                            if (state is SessionsLoaded) {
                              final list = state.page.data;
                              if (list.isEmpty) {
                                return Center(child: Text('No sessions yet'));
                              }
                              return ListView.separated(
                                itemCount: list.length,
                                separatorBuilder: (_, __) => SizedBox(height: 12.h),
                                itemBuilder: (_, i) {
                                  final s = list[i];
                                  return Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    child: ListTile(
                                      title: Text(s.name, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
                                      subtitle: Text(
                                        DateFormat('yyyy-MM-dd – HH:mm').format(s.sessionDate),
                                        style: TextStyle(color: AppColors.t2),
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => AttendancePage(
                                              students: widget.students,

                                              token: widget.token, sessionId: s.id, sessionName: s.name,
                                            ),
                                          ),
                                        );
                                      },
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.edit, color: AppColors.orange),
                                            onPressed: () => _showEditDialog(s),
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.delete, color: Colors.red),
                                            onPressed: () => _confirmDelete(s.id),
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

  void _showCreateDialog() {
    final nameCtrl = TextEditingController();
    DateTime? picked;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Create Session'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: InputDecoration(labelText: 'Name')),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: Text(
                    picked == null
                        ? 'No date chosen'
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
                  child: Text('Pick Date'),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final name = nameCtrl.text.trim();
              if (name.isEmpty || picked == null) return;
              _cubit.createSession(
                // token: widget.token,
                name: name,
                sessionDate: picked!,
                courseSectionId: widget.sectionId,
              );
            },
            child: Text('Create'),
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
        title: Text('Edit Session'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: InputDecoration(labelText: 'Name')),
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
                  child: Text('Pick Date'),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final name = nameCtrl.text.trim();
              if (name.isEmpty) return;
              _cubit.updateSession(
                // token: widget.token,
                sessionId: s.id,
                name: name,
                sessionDate: picked,
              );
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(int id) {
    showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Delete Session?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text('No')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text('Yes')),
        ],
      ),
    ).then((yes) {
      if (yes == true) {
        _cubit.deleteSession(
            // token: widget.token,
            sessionId: id);
      }
    });
  }
}
