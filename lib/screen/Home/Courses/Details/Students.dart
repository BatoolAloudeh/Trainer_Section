

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_network/image_network.dart';
import 'package:trainer_section/constant/ui/General%20constant/ConstantUi.dart';
import 'package:trainer_section/screen/Home/Courses/AddExamsAndMarks/Exams.dart'
    show ExamsOverviewPage;
import 'package:trainer_section/screen/Home/Courses/Sessions/sessionPage.dart';
import 'package:trainer_section/screen/Home/Profiles/Student.dart';

import '../../../../constant/constantKey/key.dart';
import '../../../../constant/ui/Colors/colors.dart';
import '../../../../localization/app_localizations.dart';

class StudentsSection extends StatelessWidget {
  final int idTrainer;
  final int idSection;
  final String token;
  final List<Map<String, String>> students;

  const StudentsSection({
    super.key,
    required this.students,
    required this.idTrainer,
    required this.idSection,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    if (students.isEmpty) {
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
              AppLocalizations.of(context)?.translate("nothing_to_display") ?? 'Nothing to display at this time',
              style: TextStyle(
                fontSize: 18.sp,
                color: AppColors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              AppLocalizations.of(context)?.translate("search_to_view_more") ?? 'Search to view more items',
              style: TextStyle(fontSize: 14.sp, color: AppColors.t2),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 12.h),

        // عدّاد الطلاب (يسار) + أيقونات الإجراءات (يمين)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.people_alt_rounded,
                    color: AppColors.darkBlue, size: 22.sp),
                SizedBox(width: 6.w),
                Text(
                  '${students.length} ${AppLocalizations.of(context)?.translate("students") ?? "Students"}',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkBlue,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                // العلامات (برتقالي)
                _CircleIconButton(
                  icon: Icons.grade_rounded,
                  color: AppColors.orange,
                  onTap: () {
                    navigateTo(
                      context,
                      ExamsOverviewPage(
                        students: students,
                        sectionId: idSection,
                        trainerId: idTrainer,
                        token: token,
                      ),
                    );
                  },
                ),
                SizedBox(width: 12.w),
                // الحضور (بنفسجي)
                _CircleIconButton(
                  icon: Icons.event_available_rounded,
                  color: AppColors.purple,
                  onTap: () {
                    navigateTo(
                      context,
                      SessionsPage(
                        students: students,
                        sectionId: idSection,
                        trainerId: idTrainer,
                        token: token,
                      ),
                    );
                  },
                ),
              ],
            )
          ],
        ),

        SizedBox(height: 25.h),

        // قائمة الطلاب
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.only(bottom: 12.h),
            itemCount: students.length,
            separatorBuilder: (_, __) => SizedBox(height: 12.h),
            itemBuilder: (context, i) {
              final s = students[i];
              final photoPath = s['photo'] ?? '';
              final photoUrl = photoPath.isNotEmpty ? '$BASE_URL$photoPath' : '';

              return _StudentCard(
                name: s['name'] ?? '',
                clazz: s['class'] ?? '',
                photoUrl: photoUrl,
                onDoubleTap: () {
                  navigateTo(
                    context,
                    StudentProfilePage(
                      token: token,
                      idStudent: int.parse(s['id']!),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

// زر دائري أيقوني
class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _CircleIconButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withOpacity(0.15),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(10.r),
          child: Icon(icon, color: color, size: 22.sp),
        ),
      ),
    );
  }
}

// بطاقة الطالب — تُظهر الصورة بنفس طريقة ImageNetwork + ClipOval
class _StudentCard extends StatelessWidget {
  final String name;
  final String clazz;
  final String photoUrl;
  final VoidCallback onDoubleTap;

  const _StudentCard({
    required this.name,
    required this.clazz,
    required this.photoUrl,
    required this.onDoubleTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(14.r),
      elevation: 1.5,
      shadowColor: Colors.black.withOpacity(.08),
      child: InkWell(
        onDoubleTap: onDoubleTap,
        borderRadius: BorderRadius.circular(14.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          child: Row(
            children: [
              // الصورة بنفس الآلية السابقة: ImageNetwork داخل ClipOval
              CircleAvatar(
                radius: 24.r,
                backgroundColor: AppColors.t2.withOpacity(.15),
                child: ClipOval(
                  child: photoUrl.isNotEmpty
                      ? ImageNetwork(
                    image: photoUrl,
                    width: 48.r,
                    height: 48.r,
                    fitAndroidIos: BoxFit.cover,
                    onError: const Icon(Icons.person),
                    onLoading: const SizedBox.shrink(),
                  )
                      : Icon(Icons.person, size: 22.sp, color: AppColors.t2),
                ),
              ),
              SizedBox(width: 14.w),

              // الاسم + الصف
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      clazz,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppColors.t2,
                      ),
                    ),
                  ],
                ),
              ),

              Opacity(
                opacity: .55,
                child: Icon(Icons.open_in_new_rounded,
                    size: 18.sp, color: AppColors.t3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
