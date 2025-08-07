import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trainer_section/constant/ui/Colors/colors.dart';
import 'package:trainer_section/constant/ui/General constant/ConstantUi.dart';
import 'package:trainer_section/screen/Home/Courses/Details/Files.dart';
import 'package:trainer_section/screen/Home/Courses/Details/Students.dart';
import 'package:trainer_section/screen/Home/Courses/Forum/Forum.dart';
import '../../../../Bloc/cubit/Forum/general Bloc.dart';
import '../../../../Bloc/cubit/Home/Courses/Files/delete.dart';
import '../../../../Bloc/cubit/Home/Courses/Files/showFiles.dart';
import '../../../../Bloc/cubit/Home/Courses/Files/update.dart';
import '../../../../Bloc/cubit/Home/Courses/Files/upload.dart';
import '../../../../Bloc/cubit/Home/Courses/showStudentsInSections.dart';
import '../../../../Bloc/cubit/tests/GetQuizzesBySectionId.dart';
import '../../../../Bloc/states/Home/Courses/Files/showFiles.dart';
import '../../../../Bloc/states/Home/Courses/showStudentsInSections.dart';
import '../../tests/TestsPage.dart';

enum CourseDetailTab { students, files, quizzes }

class CourseDetailsPage extends StatefulWidget {
  final int idTrainer;
  final int sectionId;
  final String title;
  final String time;
  final String day;
  final String token;

  const CourseDetailsPage({
    Key? key,
    required this.idTrainer,
    required this.sectionId,
    required this.title,
    required this.time,
    required this.day,
    required this.token,
  }) : super(key: key);

  @override
  State<CourseDetailsPage> createState() => _CourseDetailsPageState();
}

class _CourseDetailsPageState extends State<CourseDetailsPage> {
  late StudentsInSectionCubit _studentsCubit;
  late ShowFilesCubit _filesCubit;
  CourseDetailTab _selectedTab = CourseDetailTab.students;
  late ListQuizzesCubit _quizzesCubit;
  @override
  void initState() {
    super.initState();
    _studentsCubit = StudentsInSectionCubit()
      ..fetchStudentsInSection(widget.sectionId, widget.token);
    _filesCubit = ShowFilesCubit();
    _quizzesCubit = ListQuizzesCubit();
  }

  @override
  void dispose() {
    _studentsCubit.close();
    _filesCubit.close();
    _quizzesCubit.close();
    super.dispose();
  }

  // void _selectTab(CourseDetailTab tab) {
  //   setState(() {
  //     _selectedTab = tab;
  //     if (tab == CourseDetailTab.files) {
  //       _filesCubit.fetchFilesInSection(widget.sectionId,);
  //     }
  //   });
  // }

  void _selectTab(CourseDetailTab tab) {
    setState(() => _selectedTab = tab);
    if (tab == CourseDetailTab.files) {
      _filesCubit.fetchFilesInSection(widget.sectionId,widget.token);
    }
    if (tab == CourseDetailTab.quizzes) {

      _quizzesCubit.fetchQuizzesBySection(
        token: widget.token,
        sectionId: widget.sectionId,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _studentsCubit),
        BlocProvider.value(value: _filesCubit),
        BlocProvider(create: (_) => UploadFileCubit()),
        BlocProvider(create: (_) => UpdateFileCubit()),
        BlocProvider(create: (_) => DeleteFileCubit()),
        BlocProvider.value(value: _quizzesCubit),
      ],

      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Row(
          children: [
            const AppSidebar(selectedItem: SidebarItem.courses),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 24.w,
                  vertical: 24.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ─── header ─────────────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(widget.title,
                                style: TextStyle(
                                    fontSize: 22.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.darkBlue)),
                            SizedBox(width: 20.w),
                            Text(widget.time,
                                style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.darkBlue)),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BlocProvider(
                                  create: (_) => ForumCubit(),
                                  child: ForumPage(
                                    courseName: widget.title,
                                    token: widget.token,
                                    sectionId: widget.sectionId, idTrainer: widget.idTrainer,
                                  ),
                                ),
                              ),
                            );
                          },
                          child: Text('forum',
                              style: TextStyle(
                                  fontSize: 18.sp,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.darkBlue)),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    Text(widget.day,
                        style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.t2)),
                    SizedBox(height: 24.h),

                    // ─── tabs ───────────────────────────────────────
                    Row(
                      children: [
                        _buildTabLabel(
                            'Students', CourseDetailTab.students, 80.w),
                        SizedBox(width: 32.w),
                        _buildTabLabel('Files', CourseDetailTab.files, 45.w),
                        SizedBox(width: 32.w),
                        _buildTabLabel('Quizzes', CourseDetailTab.quizzes, 65.w),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Divider(height: 1.h, color: AppColors.t2),

                    // ─── content ────────────────────────────────────
                    // Expanded(
                    //   child: () {
                    //     switch (_selectedTab) {
                    //       case CourseDetailTab.students:
                    //         return _buildStudentsTab();
                    //       case CourseDetailTab.files:
                    //         return _buildFilesTab();
                    //       case CourseDetailTab.quizzes:
                    //         return TestsPage(
                    //           courseName: widget.title,
                    //           sectionId: widget.sectionId,
                    //           token: widget.token,
                    //         );
                    //     }
                    //   }(),
                    // )


                    Expanded(
                      child: () {
                        switch (_selectedTab) {
                          case CourseDetailTab.students:
                            return _buildStudentsTab();
                          case CourseDetailTab.files:
                            return _buildFilesTab();
                          case CourseDetailTab.quizzes:

                            return TestsPage(
                              courseName: widget.title,
                              sectionId: widget.sectionId,
                              token: widget.token,
                            );
                        }
                      }(),
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

  Widget _buildTabLabel(
      String label, CourseDetailTab tab, double indicatorWidth) =>
      GestureDetector(
        onTap: () => _selectTab(tab),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: _selectedTab == tab
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: _selectedTab == tab
                      ? AppColors.darkBlue
                      : AppColors.t3,
                )),
            if (_selectedTab == tab)
              Container(
                  margin: EdgeInsets.only(top: 4.h),
                  height: 2.h,
                  width: indicatorWidth,
                  color: AppColors.orange),
          ],
        ),
      );

  Widget _buildStudentsTab() {
    return BlocBuilder<StudentsInSectionCubit, StudentsInSectionState>(
      builder: (ctx, state) {
        if (state is StudentsInSectionLoading)
          return Center(child: CircularProgressIndicator());
        if (state is StudentsInSectionError)
          return Center(
              child: Text(state.message,
                  style: TextStyle(color: Colors.red, fontSize: 16.sp)));
        if (state is StudentsInSectionLoaded) {
          final section = state.sections.first;
          final data = section.students.map((stu) {
            return {
              'id': stu.id.toString(),
              'name': stu.name,
              'class': section.name,
              'photo': stu.photo
            };
          }).toList();

          return StudentsSection(
            students: data,
            idTrainer: widget.idTrainer,
            idSection: widget.sectionId, token: widget.token,
          );
        }
        return SizedBox.shrink();
      },
    );
  }

  Widget _buildFilesTab() {
    return BlocBuilder<ShowFilesCubit, ShowFilesState>(
      builder: (ctx, state) {
        if (state is ShowFilesLoading)
          return Center(child: CircularProgressIndicator());
        if (state is ShowFilesError)
          return Center(
              child: Text(state.message,
                  style: TextStyle(color: Colors.red, fontSize: 16.sp)));
        if (state is ShowFilesLoaded) {
          return FilesSection(
            files: state.files,
            sectionId: widget.sectionId,
            token: widget.token,
            onFilesChanged: () =>
                _filesCubit.fetchFilesInSection(widget.sectionId, widget.token),
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}