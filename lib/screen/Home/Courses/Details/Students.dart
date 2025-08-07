import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_network/image_network.dart';
import 'package:trainer_section/constant/ui/General%20constant/ConstantUi.dart';
import 'package:trainer_section/screen/Home/Courses/AddExamsAndMarks/Exams.dart'
    show ExamsOverviewPage, MarksSection;
import 'package:trainer_section/screen/Home/Courses/Sessions/sessionPage.dart';
import 'package:trainer_section/screen/Home/Profiles/Student.dart';

import '../../../../constant/constantKey/key.dart';
import '../../../../constant/ui/Colors/colors.dart';


class StudentsSection extends StatelessWidget {
  final int idTrainer;
  final int idSection;
  final String token;
  final List<Map<String, String>> students;
  const StudentsSection({super.key, required this.students, required this.idTrainer, required this.idSection, required this.token});

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
              'Nothing to display at this time',
              style: TextStyle(
                fontSize: 18.sp,
                color: AppColors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Search to view more items',
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
        Text(
          'You have ${students.length} students',
          style: TextStyle(fontSize: 16.sp, color: AppColors.t3),
        ),
        SizedBox(height: 20.h),
        Row(children: [
          ElevatedButton(
            onPressed: () {
              navigateTo(context,ExamsOverviewPage(
                students: students,
                sectionId: idSection,
                trainerId: idTrainer,
                token: token,
              ),);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.purple,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
            child: Text('+ Marks', style: TextStyle(fontSize: 14.sp)),
          ),

          SizedBox(width: 35.w),


          ElevatedButton(
            onPressed: () {
              navigateTo(context,SessionsPage(
                students: students,
                sectionId: idSection,
                trainerId: idTrainer,
                token: token,
              ),);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.purple,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
            child: Text('+ Student attendance', style: TextStyle(fontSize: 14.sp)),
          ),

        ],),

        SizedBox(height: 35.h),
        Expanded(
          child: ListView.separated(
            itemCount: students.length,
            separatorBuilder: (_, __) => SizedBox(height: 16.h),
            itemBuilder: (context, i) {
              final s = students[i];
              String photoUrl = s['photo'] != null
                  ? "$BASE_URL${s['photo']}"
                  : "";
              return
                ListTile(
                leading:
                  InkWell(
                  borderRadius: BorderRadius.circular(0), // حتى يتبع الدائرة

                    onDoubleTap: (){ navigateTo(context, StudentProfilePage(token: token, idStudent: int.parse(s['id']!)));},
              child:
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
                ),),),
                title:

                Text(
                  s['name']!,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                ),
                subtitle: Text(
                  s['class']!,
                  style: TextStyle(fontSize: 14.sp, color: AppColors.t2),
                ),

              );
            },
          ),
        ),
      ],
    );
  }
}

