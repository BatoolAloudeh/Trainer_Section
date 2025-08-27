import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_network/image_network.dart';
import 'package:trainer_section/constant/ui/Colors/colors.dart';
import 'package:trainer_section/constant/ui/General constant/ConstantUi.dart';
import 'package:trainer_section/network/local/cacheHelper.dart';
import 'package:trainer_section/screen/Home/Courses/MainPage/show%20Sections.dart';
import '../../../../Bloc/cubit/Home/Courses/ShowCourses.dart';
import '../../../../Bloc/states/Home/Courses/ShowCourses.dart';
import '../../../../constant/constantKey/key.dart';
import '../../../../localization/app_localizations.dart';
import '../../../../models/Home/Courses/ShowCourses.dart';

class CoursesDashboard extends StatefulWidget {
  const CoursesDashboard({Key? key}) : super(key: key);

  @override
  _CoursesDashboardState createState() => _CoursesDashboardState();
}

class _CoursesDashboardState extends State<CoursesDashboard> {
  late final String token;
  late final int idTrainer;

  _CoursesDashboardState();

  void initState() {
    super.initState();

    token = CacheHelper.getData(key: TOKENKEY) ?? '';
    idTrainer = CacheHelper.getData(key: 'idTrainer') ?? 0;

    context.read<CoursesCubit>().fetchMyCourses();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1440, 1024),
      minTextAdapt: true,
      builder:
          (_, __) => Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: Row(
              children: [
                const AppSidebar(selectedItem: SidebarItem.courses),
                // ===== Main Content =====
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 24.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(
                                    context,
                                  )?.translate("courses") ??
                                  "Courses",
                              style: TextStyle(
                                fontSize: 28.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.darkBlue,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24.h),
                        Expanded(
                          child: BlocBuilder<CoursesCubit, CoursesState>(
                            builder: (context, state) {
                              if (state is CoursesLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (state is CoursesError) {
                                return Center(
                                  child: Text(
                                    state.message,
                                    style: TextStyle(color: Colors.red),
                                  ),
                                );
                              }
                              if (state is CoursesLoaded) {
                                final sections = state.courses;
                                final Map<int, CourseDetail> uniqueCourses = {
                                  for (var sec in sections)
                                    sec.course.id: sec.course,
                                };
                                final coursesList =
                                    uniqueCourses.values.toList();

                                return LayoutBuilder(
                                  builder: (_, constraints) {
                                    int cross =
                                        constraints.maxWidth > 1200
                                            ? 4
                                            : constraints.maxWidth > 800
                                            ? 3
                                            : 2;

                                    return GridView.builder(
                                      itemCount: coursesList.length,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: cross,
                                            mainAxisSpacing: 24.h,
                                            crossAxisSpacing: 24.w,
                                            childAspectRatio: 1,
                                          ),
                                      itemBuilder: (_, i) {
                                        final course = coursesList[i];
                                        String photoUrl =
                                            course.photo != null
                                                ? "$BASE_URL${course.photo}"
                                                : "";
                                        return InkWell(
                                          onTap: () {
                                            final relatedSections =
                                                sections
                                                    .where(
                                                      (s) =>
                                                          s.course.id ==
                                                          course.id,
                                                    )
                                                    .toList();

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (_) => SectionsScreen(
                                                      course: course,
                                                      sections: relatedSections,
                                                      idTrainer: idTrainer,
                                                    ),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(16.w),
                                            decoration: BoxDecoration(
                                              color:
                                                  Theme.of(
                                                    context,
                                                  ).scaffoldBackgroundColor,
                                              borderRadius:
                                                  BorderRadius.circular(12.r),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black12,
                                                  blurRadius: 6.r,
                                                  offset: Offset(0, 4.h),
                                                ),
                                              ],
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                CircleAvatar(
                                                  radius: 80,
                                                  child: ClipOval(
                                                    child:
                                                        course.photo != null
                                                            ? ImageNetwork(
                                                              image: photoUrl,
                                                              width: 190,
                                                              height: 190,
                                                              fitAndroidIos:
                                                                  BoxFit.cover,
                                                            )
                                                            : Icon(
                                                              Icons.person,
                                                              size: 50,
                                                            ),
                                                  ),
                                                ),
                                                SizedBox(height: 12.h),
                                                Text(
                                                  course.name,
                                                  style: TextStyle(
                                                    fontSize: 18.sp,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors.darkBlue,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                SizedBox(height: 8.h),
                                                Text(
                                                  course.description,
                                                  style: TextStyle(
                                                    fontSize: 14.sp,
                                                    color: AppColors.t2,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                );
                              }
                              return const SizedBox();
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
