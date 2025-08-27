


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trainer_section/constant/ui/Colors/colors.dart';
import 'package:trainer_section/constant/ui/General constant/ConstantUi.dart';
import '../../../../constant/constantKey/key.dart';
import '../../../../localization/app_localizations.dart';
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
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ===== Header =====
                    _HeaderBanner(title: course.name),

                    SizedBox(height: 22.h),

                    // ===== Grid =====
                    Expanded(
                      child: LayoutBuilder(
                        builder: (_, constraints) {
                          final cross = constraints.maxWidth > 1200
                              ? 3
                              : (constraints.maxWidth > 820 ? 2 : 1);
                          return GridView.builder(
                            itemCount: sections.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: cross,
                              mainAxisSpacing: 16.h,
                              crossAxisSpacing: 16.w,
                              childAspectRatio: 1.78,
                            ),
                            itemBuilder: (_, i) {
                              final s = sections[i];

                              final start = s.weekDays.first.pivot.startTime.substring(0, 5);
                              final end = s.weekDays.first.pivot.endTime.substring(0, 5);
                              final day = s.weekDays.first.name;

                              final double seatsUsed = (s.reservedSeats ?? 0).toDouble();
                              final double seatsTotal = (s.seatsOfNumber ?? 1).toDouble();
                              final double seatsRatio =
                              (seatsUsed / seatsTotal).clamp(0.0, 1.0) as double;

                              return _SectionCard(
                                title: s.name,
                                day: day,
                                time: '$start - $end',
                                dateFrom: s.startDate.toString().split(' ').first,
                                dateTo: s.endDate.toString().split(' ').first,
                                seatsText: '${s.reservedSeats}/${s.seatsOfNumber}',
                                seatsRatio: seatsRatio,
                                weekChips: s.weekDays.map((wd) {
                                  final p = wd.pivot;
                                  return '${wd.name}: ${p.startTime.substring(0, 5)} - ${p.endTime.substring(0, 5)}';
                                }).toList(),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => CourseDetailsPage(
                                        sectionId: s.id,
                                        title: s.course.name,
                                        time: '$start - $end',
                                        day: day,
                                        token: CacheHelper.getData(key: TOKENKEY) as String,
                                        idTrainer: idTrainer,
                                      ),
                                    ),
                                  );
                                },
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

/// =======================================
/// Header Banner (احترافي + نظيف)
/// =======================================
class _HeaderBanner extends StatelessWidget {
  final String title;
  const _HeaderBanner({required this.title});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return Semantics(
      header: true,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.r),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              c.primary.withOpacity(.10),
              c.primary.withOpacity(.03),
            ],
          ),
          border: Border.all(color: c.primary.withOpacity(.12)),
        ),
        child: Row(
          children: [
            Container(
              height: 36.h,
              width: 6.w,
              decoration: BoxDecoration(
                color: AppColors.purple,
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.darkBlue,
                  letterSpacing: .2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// =======================================
/// Section Card (تحديث بصري احترافي)
/// =======================================
class _SectionCard extends StatefulWidget {
  final String title;
  final String day;
  final String time;
  final String dateFrom;
  final String dateTo;
  final String seatsText;
  final double seatsRatio; // 0..1
  final List<String> weekChips;
  final VoidCallback onTap;

  const _SectionCard({
    Key? key,
    required this.title,
    required this.day,
    required this.time,
    required this.dateFrom,
    required this.dateTo,
    required this.seatsText,
    required this.seatsRatio,
    required this.weekChips,
    required this.onTap,
  }) : super(key: key);

  @override
  State<_SectionCard> createState() => _SectionCardState();
}

class _SectionCardState extends State<_SectionCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final Color cardColor = Theme.of(context).cardColor;

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        transform: _hover ? (Matrix4.identity()..scale(1.012)) : Matrix4.identity(),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: _hover ? AppColors.purple.withOpacity(.18) : AppColors.purple.withOpacity(.10),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_hover ? .10 : .06),
              blurRadius: _hover ? 18.r : 12.r,
              offset: Offset(0, _hover ? 10.h : 6.h),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: widget.onTap,
          splashColor: AppColors.purple.withOpacity(.08),
          highlightColor: Colors.transparent,
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ===== Top row: badges + arrow =====
                Row(
                  children: [
                    _badge(icon: Icons.event_available, label: widget.day),
                    SizedBox(width: 8.w),
                    _badge(icon: Icons.schedule, label: widget.time),
                    const Spacer(),
                    Icon(Icons.arrow_forward_ios, size: 16.sp, color: AppColors.t3),
                  ],
                ),
                SizedBox(height: 12.h),

                // ===== Title =====
                Text(
                  widget.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.darkBlue,
                    letterSpacing: .2,
                  ),
                ),
                SizedBox(height: 8.h),

                // ===== Dates row =====
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16.sp, color: AppColors.orange),
                    SizedBox(width: 6.w),
                    Flexible(
                      child: Text(
                        '${AppLocalizations.of(context)?.translate("From") ?? "From"} ${widget.dateFrom}  →  ${AppLocalizations.of(context)?.translate("To") ?? "To"} ${widget.dateTo}',
                        style: TextStyle(fontSize: 13.sp, color: AppColors.t2),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),

                // ===== Seats & progress =====
                Row(
                  children: [
                    Icon(Icons.event_seat, size: 16.sp, color: AppColors.purple),
                    SizedBox(width: 6.w),
                    Text(
                      '${AppLocalizations.of(context)?.translate("Seats") ?? "Seats"}: ${widget.seatsText}',
                      style: TextStyle(fontSize: 13.sp, color: AppColors.t2),
                    ),
                    const Spacer(),
                    // نسبة مئوية صغيرة على اليمين
                    Text(
                      '${(widget.seatsRatio * 100).round()}%',
                      style: TextStyle(
                        fontSize: 12.5.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkBlue.withOpacity(.8),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),

                // Progress bar أنيق
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Stack(
                    children: [
                      LinearProgressIndicator(
                        value: widget.seatsRatio,
                        minHeight: 9.h,
                        backgroundColor: AppColors.t2.withOpacity(.14),
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.purple),
                      ),
                      // لمسة لمعان خفيفة أعلى البار
                      Positioned.fill(
                        child: IgnorePointer(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.white.withOpacity(.08),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 12.h),
                Divider(height: 1, color: AppColors.t2.withOpacity(.18)),

                // ===== Week chips: قابلة للتمرير =====
                SizedBox(
                  height: 74.h,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Wrap(
                      spacing: 8.w,
                      runSpacing: 6.h,
                      children: widget.weekChips
                          .map(
                            (t) => Chip(
                          label: Text(t, style: TextStyle(fontSize: 12.sp)),
                          backgroundColor: AppColors.t2.withOpacity(.08),
                          side: BorderSide(color: AppColors.t2.withOpacity(.18)),
                          visualDensity: VisualDensity.compact,
                        ),
                      )
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _badge({required IconData icon, required String label}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.t2.withOpacity(.10),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.t2.withOpacity(.12)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: AppColors.orange),
          SizedBox(width: 6.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.t2,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
