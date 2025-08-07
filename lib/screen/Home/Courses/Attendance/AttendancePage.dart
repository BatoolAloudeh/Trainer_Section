// lib/screens/sessions/AttendancePage.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_network/image_network.dart';

import '../../../../Bloc/cubit/Attendence/attendence.dart';
import '../../../../Bloc/states/Attendence/attendence.dart';
import '../../../../constant/constantKey/key.dart';

import '../../../../constant/ui/Colors/colors.dart';
import '../../../../models/Attendence/attendence.dart';
//
//
// class AttendancePage extends StatefulWidget {
//   final int sessionId;
//   final String token;
//   final List<Map<String, String>> students;
//
//   const AttendancePage({
//     Key? key,
//     required this.sessionId,
//     required this.token,
//     required this.students, required int trainerId,
//   }) : super(key: key);
//
//   @override
//   _AttendancePageState createState() => _AttendancePageState();
// }
//
// class _AttendancePageState extends State<AttendancePage> {
//   late AttendanceCubit _cubit;
//
//   @override
//   void initState() {
//     super.initState();
//     _cubit = AttendanceCubit()
//       ..fetchAttendance(
//         token: widget.token,
//         sessionId: widget.sessionId,
//       );
//   }
//
//   @override
//   void dispose() {
//     _cubit.close();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     ScreenUtil.init(context);
//
//     return BlocProvider.value(
//       value: _cubit,
//       child: BlocListener<AttendanceCubit, AttendanceState>(
//         listener: (ctx, state) {
//           if (state is AttendanceMarked ||
//               state is AttendanceUpdated ||
//               state is AttendanceDeleted) {
//             // بعد أي تعديل نعيد جلب البيانات
//             WidgetsBinding.instance.addPostFrameCallback((_) {
//               ctx.read<AttendanceCubit>().fetchAttendance(
//                 token: widget.token,
//                 sessionId: widget.sessionId,
//               );
//             });
//           }
//         },
//         child: Scaffold(
//           backgroundColor: AppColors.w1,
//           appBar: AppBar(
//             title: Text('Attendance', style: TextStyle(color: AppColors.darkBlue)),
//             backgroundColor: AppColors.w1,
//             iconTheme: IconThemeData(color: AppColors.darkBlue),
//             elevation: 0,
//           ),
//           body: BlocBuilder<AttendanceCubit, AttendanceState>(
//             builder: (ctx, state) {
//               if (state is AttendanceLoading) {
//                 return const Center(child: CircularProgressIndicator());
//               }
//               if (state is AttendanceError) {
//                 return Center(child: Text(state.message));
//               }
//               if (state is AttendanceLoaded) {
//                 final records = state.list;
//                 return ListView.separated(
//                   padding: EdgeInsets.all(16.w),
//                   itemCount: widget.students.length,
//                   separatorBuilder: (_, __) => SizedBox(height: 12.h),
//
//                   // داخل ListView.builder:
//                   itemBuilder: (_, idx) {
//                     final s = widget.students[idx];
//                     final sid = int.parse(s['id']!);
//
//                     // 1) نحاول إيجاد سجل الحضور:
//                     AttendanceModel? rec;
//                     try {
//                       rec = records.firstWhere((r) => r.studentId == sid);
//                     } catch (_) {
//                       rec = null;
//                     }
//
//                     // 2) نستخرج الحالة:
//                     final isPresent = rec?.isPresent ?? false;
//
//                     return Card(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12.r),
//                       ),
//                       child: ListTile(
//                         leading: CircleAvatar(
//                           radius: 20.r,
//                           backgroundImage: s['photo']!.isNotEmpty
//                               ? NetworkImage('$BASE_URL${s['photo']}')
//                               : null,
//                           child: s['photo']!.isEmpty ? Icon(Icons.person) : null,
//                         ),
//                         title: Text(s['name']!, style: TextStyle(fontSize: 16.sp)),
//                         subtitle: Text(s['class']!, style: TextStyle(color: AppColors.t2)),
//                         trailing: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             // أيقونة الحضور/الغياب
//                             GestureDetector(
//                               onTap: () {
//                                 if (rec == null) {
//                                   // إذا لم يُسجَّل من قبل، نستخدم mark
//                                   ctx.read<AttendanceCubit>().markAttendance(
//                                     token: widget.token,
//                                     sessionId: widget.sessionId,
//                                     studentId: sid,
//                                     isPresent: true,
//                                   );
//                                 } else {
//                                   // وإلّا نحدّثه
//                                   ctx.read<AttendanceCubit>().updateAttendance(
//                                     token: widget.token,
//                                     attendanceId: rec.id,
//                                     isPresent: !isPresent,
//                                   );
//                                 }
//                               },
//                               child: Icon(
//                                 isPresent
//                                     ? Icons.check_circle
//                                     : Icons.check_circle_outline,
//                                 size: 28.sp,
//                                 color: AppColors.orange,
//                               ),
//                             ),
//
//                             SizedBox(width: 16.w),
//
//                             // حذف بالسحب الطويل
//                             if (rec != null)
//                               GestureDetector(
//                                 onLongPress: () {
//                                   ctx.read<AttendanceCubit>().deleteAttendance(
//                                     token: widget.token,
//                                     attendanceId: rec!.id,
//                                   );
//                                 },
//                                 child: Icon(
//                                   Icons.delete_outline,
//                                   size: 24.sp,
//                                   color: Colors.redAccent,
//                                 ),
//                               ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//
//
//                 );
//               }
//               return const SizedBox.shrink();
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
//












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
    _cubit = AttendanceCubit()
      ..fetchAttendance(
          // token: widget.token,
          sessionId: widget.sessionId);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    ScreenUtil.init(context,
        designSize: const Size(1440, 1024), minTextAdapt: true);

    return BlocProvider.value(
      value: _cubit,
      child: BlocListener<AttendanceCubit, AttendanceState>(
        listener: (ctx, state) {
          if (state is AttendanceMarked ||
              state is AttendanceUpdated ||
              state is AttendanceDeleted) {

            WidgetsBinding.instance.addPostFrameCallback((_) {
              ctx.read<AttendanceCubit>().fetchAttendance(
                // token: widget.token,
                sessionId: widget.sessionId,
              );
            });
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
                        children: [

                          SizedBox(width: 8.w),
                          Text(
                            'Attendance for "${widget.sessionName}"',
                            style: TextStyle(
                              fontSize: 28.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkBlue,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),


                      Expanded(
                        child: BlocBuilder<AttendanceCubit, AttendanceState>(
                          builder: (ctx, state) {
                            if (state is AttendanceLoading) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            if (state is AttendanceError) {
                              return Center(child: Text(state.message));
                            }
                            if (state is AttendanceLoaded) {
                              final records = state.list;
                              if (widget.students.isEmpty) {
                                return Center(child: Text('No students'));
                              }
                              return ListView.separated(
                                itemCount: widget.students.length,
                                separatorBuilder: (_, __) => SizedBox(height: 12.h),
                                itemBuilder: (_, idx) {
                                  final s = widget.students[idx];
                                  final sid = int.parse(s['id']!);


                                  AttendanceModel? rec;
                                  try {
                                    rec = records.firstWhere((r) => r.studentId == sid);
                                  } catch (_) {
                                    rec = null;
                                  }
                                  final isPresent = rec?.isPresent ?? false;
                                  String photoUrl = s['photo'] != null
                                      ? "$BASE_URL${s['photo']}"
                                      : "";
                                  return Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    child: ListTile(
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 16.w,
                                        vertical: 8.h,
                                      ),
                                      leading:   CircleAvatar(
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
                                      title: Text(
                                        s['name']!,
                                        style: TextStyle(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(
                                        s['class']!,
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: AppColors.t2,
                                        ),
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // ✔️ حاضر
                                          GestureDetector(
                                            onTap: () {
                                              if (rec == null) {
                                                _cubit.markAttendance(
                                                  // token: widget.token,
                                                  sessionId: widget.sessionId,
                                                  studentId: sid,
                                                  isPresent: true,
                                                );
                                              } else {
                                                _cubit.updateAttendance(
                                                  // token: widget.token,
                                                  attendanceId: rec.id,
                                                  isPresent: true,
                                                );
                                              }
                                            },
                                            child: Icon(
                                              isPresent
                                                  ? Icons.check_circle
                                                  : Icons.check_circle_outline,
                                              size: 24.sp,
                                              color: isPresent
                                                  ? AppColors.orange
                                                  : AppColors.t2,
                                            ),
                                          ),
                                          SizedBox(width: 16.w),

                                          GestureDetector(
                                            onTap: () {
                                              if (rec == null) {
                                                _cubit.markAttendance(
                                                  // token: widget.token,
                                                  sessionId: widget.sessionId,
                                                  studentId: sid,
                                                  isPresent: false,
                                                );
                                              } else {
                                                _cubit.updateAttendance(
                                                  // token: widget.token,
                                                  attendanceId: rec.id,
                                                  isPresent: false,
                                                );
                                              }
                                            },
                                            child: Icon(
                                              !isPresent
                                                  ? Icons.cancel
                                                  : Icons.cancel_outlined,
                                              size: 24.sp,
                                              color: !isPresent
                                                  ? AppColors.orange
                                                  : AppColors.t2,
                                            ),
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
}
