

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../Bloc/cubit/Calendar/calendar.dart';
import '../../Bloc/states/Calendar/calendar.dart';
import '../../constant/ui/Colors/colors.dart';
import '../../constant/ui/General constant/ConstantUi.dart';
import '../../localization/app_localizations.dart';

class CalendarPage extends StatefulWidget {
  final String token;
  const CalendarPage({Key? key, required this.token}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late ScheduleCubit _cubit;
  late int _year, _month;
  DateTime? _selectedDate;

  static const List<String> _weekDays = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday',
  ];

  @override
  void initState() {
    super.initState();
    _cubit = ScheduleCubit();
    final now = DateTime.now();
    _year = now.year;
    _month = now.month;
    _selectedDate = now;
    _fetchForDate(now);
  }

  void _fetchForDate(DateTime date) {
    final dayName = DateFormat('EEEE').format(date).toLowerCase();
    _cubit.fetchByDay(dayName: dayName, token: widget.token);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  List<DateTime?> _daysInMonth(int year, int month) {
    final first = DateTime(year, month, 1);
    final total = DateUtils.getDaysInMonth(year, month);
    final leading = first.weekday - DateTime.monday; // 0..6
    final days = <DateTime?>[...List<DateTime?>.filled(leading, null)];
    for (var i = 1; i <= total; i++) {
      days.add(DateTime(year, month, i));
    }
    return days;
  }

  void _onTapDay(DateTime? date) {
    if (date == null) return;
    setState(() => _selectedDate = date);
    _fetchForDate(date);
  }

  void _goToPrevMonth() {
    final d = DateTime(_year, _month - 1, 1);
    setState(() {
      _year = d.year;
      _month = d.month;
      _selectedDate = null;
    });
  }

  void _goToNextMonth() {
    final d = DateTime(_year, _month + 1, 1);
    setState(() {
      _year = d.year;
      _month = d.month;
      _selectedDate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(1440, 1024), minTextAdapt: true);
    final tr = AppLocalizations.of(context)?.translate;

    final days = _daysInMonth(_year, _month);
    final monthName = DateFormat.MMMM().format(DateTime(_year, _month));
    final yearName = '$_year';
    final today = DateTime.now();

    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Row(
          children: [
            const AppSidebar(selectedItem: SidebarItem.calendar),
            Expanded(
              child: Column(
                children: [
                  // ---------- Top bar inside content ----------
                  Container(
                    height: 64.h,
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      border: Border(bottom: BorderSide(color: Colors.black12.withOpacity(0.06))),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            tr?.call('Calendar') ?? 'Calendar',
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w800,
                              color: AppColors.darkBlue,
                            ),
                          ),
                        ),
                        // Month navigation
                        _RoundIconBtn(icon: Icons.chevron_left_rounded, onTap: _goToPrevMonth),
                        SizedBox(width: 8.w),
                        _buildDropdown(
                          value: monthName,
                          items: List.generate(12, (i) => DateFormat.MMMM().format(DateTime(0, i + 1))),
                          onChanged: (m) {
                            if (m == null) return;
                            final idx = DateFormat.MMMM().dateSymbols.MONTHS.indexOf(m) + 1;
                            setState(() {
                              _month = idx;
                              _selectedDate = null;
                            });
                          },
                        ),
                        SizedBox(width: 12.w),
                        _buildDropdown(
                          value: yearName,
                          items: List.generate(7, (i) => '${DateTime.now().year - 3 + i}'),
                          onChanged: (y) {
                            if (y == null) return;
                            setState(() {
                              _year = int.parse(y);
                              _selectedDate = null;
                            });
                          },
                        ),
                        SizedBox(width: 8.w),
                        _RoundIconBtn(icon: Icons.chevron_right_rounded, onTap: _goToNextMonth),
                      ],
                    ),
                  ),

                  // ---------- Content ----------
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 24.h),
                      child: Container(
                        padding: EdgeInsets.all(24.w),
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(18.r),
                          border: Border.all(color: Colors.black12.withOpacity(0.06)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 12.r,
                              offset: Offset(0, 6.h),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Weekday header
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4.w),
                              child: Row(
                                children: _weekDays.map((d) {
                                  return Expanded(
                                    child: Center(
                                      child: Text(
                                        tr?.call(d) ?? d,
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: AppColors.t3,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: .3,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            SizedBox(height: 12.h),

                            // Days grid
                            Expanded(
                              child: GridView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemCount: days.length,
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 7,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                ),
                                itemBuilder: (_, i) {
                                  final dt = days[i];
                                  final isSelected = dt != null && _selectedDate != null && DateUtils.isSameDay(dt, _selectedDate);
                                  final isToday = dt != null && DateUtils.isSameDay(dt, today);

                                  return _DayCell(
                                    date: dt,
                                    isSelected: isSelected,
                                    isToday: isToday,
                                    onTap: () => _onTapDay(dt),
                                  );
                                },
                              ),
                            ),

                            // Events / tasks area
                            SizedBox(height: 8.h),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                tr?.call('Tasks for the day') ?? 'Tasks for the day',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.darkBlue,
                                ),
                              ),
                            ),
                            SizedBox(height: 8.h),

                            BlocBuilder<ScheduleCubit, ScheduleState>(
                              builder: (_, state) {
                                if (state is ScheduleLoading) {
                                  return Padding(
                                    padding: EdgeInsets.only(top: 8.h),
                                    child: const Center(child: CircularProgressIndicator()),
                                  );
                                }
                                if (state is ScheduleError) {
                                  return Padding(
                                    padding: EdgeInsets.only(top: 8.h),
                                    child: Text(
                                      '${tr?.call('Error') ?? 'Error'}: ${state.message}',
                                      style: TextStyle(color: Colors.red, fontSize: 14.sp),
                                    ),
                                  );
                                }
                                if (state is ScheduleLoaded) {
                                  final evs = state.events;
                                  if (evs.isEmpty) {
                                    return Padding(
                                      padding: EdgeInsets.only(top: 6.h),
                                      child: Text(
                                        tr?.call('dont have tasks for today') ?? 'dont have tasks for today',
                                        style: TextStyle(color: AppColors.t2, fontSize: 14.sp),
                                      ),
                                    );
                                  }
                                  return Column(
                                    children: evs.map((e) {
                                      return Container(
                                        margin: EdgeInsets.only(bottom: 8.h),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12.r),
                                          border: Border.all(color: Colors.black12.withOpacity(0.06)),
                                        ),
                                        child: ListTile(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                                          leading: Container(
                                            width: 36.w,
                                            height: 36.w,
                                            decoration: BoxDecoration(
                                              color: AppColors.purple.withOpacity(.12),
                                              borderRadius: BorderRadius.circular(10.r),
                                            ),
                                            child: Icon(Icons.event, color: AppColors.purple, size: 20.sp),
                                          ),
                                          title: Text(e.course.name, style: TextStyle(fontWeight: FontWeight.w600)),
                                          subtitle: Text(
                                            '${e.section.name} • ${e.startTime} - ${e.endTime}',
                                            style: TextStyle(color: AppColors.t3, fontSize: 12.sp),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  );
                                }
                                return const SizedBox();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- UI helpers ----------

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.purple.withOpacity(.35)),
        borderRadius: BorderRadius.circular(28.r),
      ),
      child: DropdownButton<String>(
        value: value,
        underline: const SizedBox(),
        isDense: true,
        style: TextStyle(color: AppColors.darkBlue, fontSize: 13.sp),
        items: items.map((v) => DropdownMenuItem<String>(value: v, child: Text(v))).toList(),
        onChanged: onChanged,
      ),
    );
  }
}

class _RoundIconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _RoundIconBtn({required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.w1,
      borderRadius: BorderRadius.circular(24.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(24.r),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(8.w),
          child: Icon(icon, size: 22.sp, color: AppColors.t3),
        ),
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  final DateTime? date;
  final bool isSelected;
  final bool isToday;
  final VoidCallback onTap;

  const _DayCell({
    required this.date,
    required this.isSelected,
    required this.isToday,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = Theme.of(context).scaffoldBackgroundColor;

    if (date == null) {
      return const SizedBox.shrink();
    }

    Color border = isSelected ? AppColors.orange : AppColors.purple.withOpacity(.35);
    Color text = isSelected ? Colors.white : AppColors.darkBlue;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.orange : bg,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: border),
        boxShadow: [
          if (isSelected)
            BoxShadow(
              color: AppColors.orange.withOpacity(.25),
              blurRadius: 14.r,
              offset: Offset(0, 6.h),
            ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14.r),
        onTap: onTap,
        child: Stack(
          children: [
            // Today ring (subtle)
            if (isToday && !isSelected)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(color: AppColors.orange.withOpacity(.5), width: 1),
                  ),
                ),
              ),
            // Day number
            Center(
              child: Text(
                '${date!.day}',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: text,
                ),
              ),
            ),
            // Corner month label if first day
            if (date!.day == 1)
              Positioned(
                left: 8.w,
                top: 6.h,
                child: Text(
                  DateFormat.MMM().format(date!),
                  style: TextStyle(fontSize: 10.sp, color: isSelected ? Colors.white70 : AppColors.t3),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
