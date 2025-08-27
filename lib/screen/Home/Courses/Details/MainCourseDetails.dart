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
import '../../../../Bloc/cubit/progress/progress.dart';
import '../../../../Bloc/cubit/tests/GetQuizzesBySectionId.dart';
import '../../../../Bloc/states/Home/Courses/Files/showFiles.dart';
import '../../../../Bloc/states/Home/Courses/showStudentsInSections.dart';
import '../../../../Bloc/states/progress/progress.dart';
import '../../../../localization/app_localizations.dart';
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
  late ListQuizzesCubit _quizzesCubit;
  late SectionProgressCubit _progressCubit;

  CourseDetailTab _selectedTab = CourseDetailTab.students;

  @override
  void initState() {
    super.initState();
    _studentsCubit = StudentsInSectionCubit()
      ..fetchStudentsInSection(widget.sectionId, widget.token);
    _filesCubit = ShowFilesCubit();
    _quizzesCubit = ListQuizzesCubit();
    _progressCubit = SectionProgressCubit()
      ..fetchSectionProgress(sectionId: widget.sectionId);
  }

  @override
  void dispose() {
    _studentsCubit.close();
    _filesCubit.close();
    _quizzesCubit.close();
    _progressCubit.close();
    super.dispose();
  }

  void _selectTab(CourseDetailTab tab) {
    setState(() => _selectedTab = tab);
    if (tab == CourseDetailTab.files) {
      _filesCubit.fetchFilesInSection(widget.sectionId, widget.token);
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
    final theme = Theme.of(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _studentsCubit),
        BlocProvider.value(value: _filesCubit),
        BlocProvider(create: (_) => UploadFileCubit()),
        BlocProvider(create: (_) => UpdateFileCubit()),
        BlocProvider(create: (_) => DeleteFileCubit()),
        BlocProvider.value(value: _quizzesCubit),
        BlocProvider.value(value: _progressCubit),
      ],
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: Row(
          children: [
            const AppSidebar(selectedItem: SidebarItem.courses),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _HeaderCard(
                      title: widget.title,
                      time: widget.time,
                      day: widget.day,
                      forumLabel: AppLocalizations.of(context)?.translate("forum") ?? 'Forum',
                      onOpenForum: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider(
                              create: (_) => ForumCubit(),
                              child: ForumPage(
                                courseName: widget.title,
                                token: widget.token,
                                sectionId: widget.sectionId,
                                idTrainer: widget.idTrainer,
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 16.h),

                    // Progress card
                    Card(
                      elevation: 0,
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                        side: BorderSide(color: AppColors.darkBlue.withOpacity(.08)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
                        child: Align(
                          alignment: Alignment.center,
                          child: BlocBuilder<SectionProgressCubit, SectionProgressState>(
                            builder: (context, state) {
                              final percent = state is SectionProgressSuccess
                                  ? (state.data.progressPercentage.toDouble())
                                  : 0.0;
                              return Semantics(
                                label: 'Section progress',
                                value: '${percent.round()}%',
                                child: _ProgressRing(
                                  percent: percent,     // 0..100
                                  size: 150,           // واضح وجميل
                                  stroke: 12,          // سماكة أنيقة
                                  color: theme.colorScheme.primary,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 18.h),

                    // Segmented tabs
                    _SegmentedTabs(
                      leftLabel: AppLocalizations.of(context)?.translate("students") ?? 'Students',
                      centerLabel: AppLocalizations.of(context)?.translate("files") ?? 'Files',
                      rightLabel: AppLocalizations.of(context)?.translate("quizzes") ?? 'Quizzes',
                      selected: _selectedTab,
                      onSelect: _selectTab,
                    ),

                    SizedBox(height: 16.h),

                    // Content container
                    Expanded(
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                          side: BorderSide(color: AppColors.t2.withOpacity(.14)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16.w),
                          child: _buildBody(),
                        ),
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

  Widget _buildBody() {
    switch (_selectedTab) {
      case CourseDetailTab.students:
        return _buildStudentsTab();
      case CourseDetailTab.files:
        return _buildFilesTab();
      case CourseDetailTab.quizzes:
        return TestsPage(
          courseName: widget.title,
          sectionId: widget.sectionId,
          token: widget.token, idTrainer: widget.idTrainer,day:widget.day ,time:widget.time ,
        );
    }
  }

  Widget _buildStudentsTab() {
    return BlocBuilder<StudentsInSectionCubit, StudentsInSectionState>(
      builder: (ctx, state) {
        if (state is StudentsInSectionLoading) {
          return const _CenteredLoader();
        }
        if (state is StudentsInSectionError) {
          return _ErrorState(message: state.message);
        }
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
            idSection: widget.sectionId,
            token: widget.token,
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildFilesTab() {
    return BlocBuilder<ShowFilesCubit, ShowFilesState>(
      builder: (ctx, state) {
        if (state is ShowFilesLoading) {
          return const _CenteredLoader();
        }
        if (state is ShowFilesError) {
          return _ErrorState(message: state.message);
        }
        if (state is ShowFilesLoaded) {
          return FilesSection(
            files: state.files,
            sectionId: widget.sectionId,
            token: widget.token,
            onFilesChanged: () =>
                _filesCubit.fetchFilesInSection(widget.sectionId, widget.token),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

/// --------------------
/// UI Subcomponents
/// --------------------

class _HeaderCard extends StatelessWidget {
  final String title;
  final String time;
  final String day;
  final VoidCallback onOpenForum;
  final String forumLabel;

  const _HeaderCard({
    Key? key,
    required this.title,
    required this.time,
    required this.day,
    required this.onOpenForum,
    required this.forumLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            c.primary.withOpacity(.10),
            c.primary.withOpacity(.02),
          ],
        ),
        border: Border.all(color: c.primary.withOpacity(.12)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 14.w,
            runSpacing: 10.h,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.darkBlue,
                  letterSpacing: .2,
                ),
              ),
              _Chip(text: time, bg: AppColors.darkBlue.withOpacity(.06), fg: AppColors.darkBlue),
              _Chip(text: day, bg: AppColors.t2.withOpacity(.08), fg: AppColors.t2),
            ],
          ),
          _PrimaryButton(
            label: forumLabel,
            onTap: onOpenForum,
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String text;
  final Color bg;
  final Color fg;

  const _Chip({super.key, required this.text, required this.bg, required this.fg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: fg.withOpacity(.10)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13.5.sp,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const _PrimaryButton({super.key, required this.label, required this.onTap});

  @override
  State<_PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<_PrimaryButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.darkBlue;
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: _hover ? c.withOpacity(.95) : c,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: c.withOpacity(.22),
                blurRadius: 14,
                offset: const Offset(0, 8),
              )
            ],
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 14.sp,
            ),
          ),
        ),
      ),
    );
  }
}

class _SegmentedTabs extends StatelessWidget {
  final String leftLabel;
  final String centerLabel;
  final String rightLabel;
  final CourseDetailTab selected;
  final ValueChanged<CourseDetailTab> onSelect;

  const _SegmentedTabs({
    super.key,
    required this.leftLabel,
    required this.centerLabel,
    required this.rightLabel,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final isL = selected == CourseDetailTab.students;
    final isC = selected == CourseDetailTab.files;
    final isR = selected == CourseDetailTab.quizzes;

    // ✅ استخدم AlignmentDirectional بدل Alignment
    final AlignmentGeometry indicatorAlign = isL
        ? AlignmentDirectional.centerStart
        : (isC ? AlignmentDirectional.center : AlignmentDirectional.centerEnd);

    return Semantics(
      label: 'Course tabs',
      child: Container(
        height: 48.h,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.t2.withOpacity(.25)),
        ),
        child: Stack(
          children: [
            // ✅ هذا المؤشر الآن ينقلب تلقائيًا مع RTL/LTR
            AnimatedAlign(
              alignment: indicatorAlign,
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              child: const FractionallySizedBox(
                widthFactor: 1 / 3, // ثلث العرض دائمًا
                heightFactor: 1,
                child: Padding(
                  padding: EdgeInsets.all(2),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Color(0x14000000), // أي لون نصف شفاف
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                ),
              ),
            ),

            // ✅ خَلّي Row يتبع اتجاه الواجهة الحالية
            Row(
              textDirection: Directionality.of(context),
              children: [
                _SegItem(
                  label: leftLabel,   // "الطلاب"
                  active: isL,
                  onTap: () => onSelect(CourseDetailTab.students),
                ),
                _SegItem(
                  label: centerLabel, // "الملفات"
                  active: isC,
                  onTap: () => onSelect(CourseDetailTab.files),
                ),
                _SegItem(
                  label: rightLabel,  // "الاختبارات"
                  active: isR,
                  onTap: () => onSelect(CourseDetailTab.quizzes),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


class _SegItem extends StatefulWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _SegItem({super.key, required this.label, required this.active, required this.onTap});

  @override
  State<_SegItem> createState() => _SegItemState();
}

class _SegItemState extends State<_SegItem> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final base = widget.active ? AppColors.darkBlue : AppColors.t3;
    return Expanded(
      child: MouseRegion(
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: Semantics(
            button: true,
            selected: widget.active,
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 160),
              style: TextStyle(
                fontSize: widget.active ? 16.sp : 15.sp,
                fontWeight: widget.active ? FontWeight.w800 : FontWeight.w600,
                color: _hover ? base.withOpacity(.95) : base,
                letterSpacing: .2,
              ),
              child: Center(child: Text(widget.label)),
            ),
          ),
        ),
      ),
    );
  }
}

class _CenteredLoader extends StatelessWidget {
  const _CenteredLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  const _ErrorState({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(.06),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red.withOpacity(.20)),
        ),
        child: Text(
          message,
          style: TextStyle(color: Colors.red.shade700, fontSize: 14.5.sp, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

/// حلقة تقدّم أنيقة دون خلفية بيضاء + توهّج خفيف + النسبة داخلها
class _ProgressRing extends StatelessWidget {
  final double percent; // 0..100
  final double size;
  final double stroke;
  final Color color;

  const _ProgressRing({
    Key? key,
    required this.percent,
    this.size = 170,
    this.stroke = 12,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final v = (percent.clamp(0, 100)) / 100.0;
    final fg = color;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // توهج خارجي بسيط (glow)
          IgnorePointer(
            child: Container(
              width: size * .92,
              height: size * .92,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: fg.withOpacity(.28),
                    blurRadius: 22,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),

          // مسار التقدم فقط (بدون خلفية)
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: v),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutCubic,
            builder: (context, value, _) {
              return CustomPaint(
                size: Size.square(size),
                painter: _ArcPainter(
                  progress: value,
                  color: fg,
                  stroke: stroke,
                ),
              );
            },
          ),

          // النسبة في الوسط
          Text(
            '${percent.round()} %',
            style: TextStyle(
              fontSize: size * 0.22,
              fontWeight: FontWeight.w800,
              color: Theme.of(context).textTheme.bodyLarge?.color,
              height: 1,
              letterSpacing: .5,
            ),
          ),
        ],
      ),
    );
  }
}

class _ArcPainter extends CustomPainter {
  final double progress; // 0..1
  final double stroke;
  final Color color;

  _ArcPainter({
    required this.progress,
    required this.stroke,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    final start = -90 * (3.14159265 / 180); // من الأعلى
    final sweep = 2 * 3.14159265 * progress;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        startAngle: 0,
        endAngle: 2 * 3.14159265,
        colors: [
          color.withOpacity(.75),
          color,
          color.withOpacity(.9),
        ],
        stops: const [0.0, 0.6, 1.0],
      ).createShader(rect);

    final center = size.center(Offset.zero);
    final radius = (size.shortestSide - stroke) / 2;

    // مسار الخلفية الشفاف قليلًا لإحساس التقدم
    final bgPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..color = color.withOpacity(.12);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      0,
      2 * 3.14159265,
      false,
      bgPaint,
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      start,
      sweep,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_ArcPainter oldDelegate) =>
      oldDelegate.progress != progress ||
          oldDelegate.color != color ||
          oldDelegate.stroke != stroke;
}
