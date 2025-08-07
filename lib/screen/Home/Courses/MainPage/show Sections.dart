
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trainer_section/constant/ui/Colors/colors.dart';
import 'package:trainer_section/constant/ui/General constant/ConstantUi.dart';
import '../../../../constant/constantKey/key.dart';
import '../../../../models/Home/Courses/ShowCourses.dart';
import '../../../../network/local/cacheHelper.dart';
import '../Details/MainCourseDetails.dart';

class SectionsScreen extends StatelessWidget {
  final int idTrainer;
  final CourseDetail course;
  final List<TrainerCourse> sections;
  const SectionsScreen({
    Key? key,
    required this.course,
    required this.sections,
    required this.idTrainer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1440, 1024),
      minTextAdapt: true,
      builder: (_, __) => Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Row(
          children: [
            const AppSidebar(selectedItem: SidebarItem.courses),

            Expanded(
              child: Padding(
                padding:
                EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.name,
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkBlue,
                      ),
                    ),
                    SizedBox(height: 35.h),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (_, constraints) {
                          final cross = constraints.maxWidth > 800 ? 2 : 1;
                          return GridView.builder(
                            itemCount: sections.length,
                            gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: cross,
                              mainAxisSpacing: 16.h,
                              crossAxisSpacing: 16.w,
                              childAspectRatio: 2.5,
                            ),
                            itemBuilder: (_, i) {
                              final s = sections[i];
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => CourseDetailsPage(
                                        sectionId: s.id,
                                        title: s.course.name,
                                        time:
                                        '${s.weekDays.first.pivot.startTime.substring(0, 5)} - ${s.weekDays.first.pivot.endTime.substring(0, 5)}',
                                        day: s.weekDays.first.name,
                                        token: CacheHelper.getData(
                                            key: TOKENKEY) as String,
                                        idTrainer: idTrainer,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.all(16.w),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    borderRadius: BorderRadius.circular(12.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 4.r,
                                        offset: Offset(0, 2.h),
                                      ),
                                    ],
                                  ),

                                  // هُنَا المهم: mainAxisSize.min
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(height: 16.h),
                                      Text(
                                        s.name,
                                        style: TextStyle(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.darkBlue,
                                        ),
                                      ),
                                      SizedBox(height: 8.h),
                                      Chip(
                                        label: Text(
                                          'Date: From: ${s.startDate.toString().split(' ')[0]} → To: ${s.endDate.toString().split(' ')[0]}',
                                          style: TextStyle(fontSize: 12.sp),
                                        ),
                                      ),
                                      SizedBox(height: 8.h),
                                      Text(
                                        'Seats: ${s.reservedSeats}/${s.seatsOfNumber}',
                                        style: TextStyle(fontSize: 14.sp),
                                      ),
                                      SizedBox(height: 8.h),


                                      Wrap(
                                        spacing: 8.w,
                                        runSpacing: 4.h,
                                        children: s.weekDays.map((wd) {
                                          final p = wd.pivot;
                                          return Chip(
                                            label: Text(
                                              '${wd.name}: ${p.startTime.substring(0, 5)} - ${p.endTime.substring(0, 5)}',
                                              style: TextStyle(fontSize: 12.sp),
                                            ),
                                            visualDensity: VisualDensity.compact,
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
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
    );
  }
}
