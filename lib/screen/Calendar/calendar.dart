// lib/screens/calendar/CalendarPage.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../Bloc/cubit/Calendar/calendar.dart';
import '../../Bloc/states/Calendar/calendar.dart';
import '../../constant/ui/Colors/colors.dart';
import '../../constant/ui/General constant/ConstantUi.dart'; // هذا فيه AppSidebar, SidebarItem




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
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
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
    final leading = first.weekday - DateTime.monday;
    final days = <DateTime?>[...List<DateTime?>.filled(leading, null)];
    for (var i = 1; i <= total; i++) {
      days.add(DateTime(year, month, i));
    }
    return days;
  }

  void _onTapDay(DateTime? date) {
    if (date == null) return;
    setState(() {
      _selectedDate = date;
    });
    _fetchForDate(date);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: const Size(1440, 1024), minTextAdapt: true);

    final days = _daysInMonth(_year, _month);
    final monthName = DateFormat.MMMM().format(DateTime(_year, _month));
    final yearName = '$_year';

    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Row(
          children: [
            const AppSidebar(selectedItem: SidebarItem.calendar),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 24.w, vertical: 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Calendar',
                          style: TextStyle(
                            fontSize: 32.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkBlue,
                          ),
                        ),
                        Row(
                          children: [
                            _buildDropdown(
                              value: monthName,
                              items: List.generate(12, (i) {
                                return DateFormat.MMMM()
                                    .format(DateTime(0, i + 1));
                              }),
                              onChanged: (m) {
                                if (m == null) return;
                                final idx = DateFormat.MMMM()
                                    .dateSymbols
                                    .MONTHS
                                    .indexOf(m) +
                                    1;
                                setState(() {
                                  _month = idx;
                                  _selectedDate = null;
                                });
                              },
                            ),
                            SizedBox(width: 16.w),
                            _buildDropdown(
                              value: yearName,
                              items: List.generate(5, (i) {
                                final y = DateTime.now().year - 2 + i;
                                return '$y';
                              }),
                              onChanged: (y) {
                                if (y == null) return;
                                setState(() {
                                  _year = int.parse(y);
                                  _selectedDate = null;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),


                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(24.w),
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8.r,
                              offset: Offset(0, 4.h),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [

                            Row(
                              children: _weekDays.map((d) {
                                return Expanded(
                                  child: Center(
                                    child: Text(
                                      d,
                                      style: TextStyle(
                                        color: AppColors.t3,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            SizedBox(height: 12.h),

                            // شبكة الأيام
                            Expanded(
                              child: GridView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemCount: days.length,
                                gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 7,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                ),
                                itemBuilder: (_, i) {
                                  final dt = days[i];
                                  final isSel = dt != null &&
                                      _selectedDate != null &&
                                      DateUtils.isSameDay(
                                          dt, _selectedDate);
                                  return GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () => _onTapDay(dt),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: isSel
                                            ? AppColors.orange
                                            : Theme.of(context).scaffoldBackgroundColor,
                                        border: Border.all(
                                          color: dt == null
                                              ? Colors.transparent
                                              : isSel
                                              ? AppColors.orange
                                              : AppColors.purple,
                                        ),
                                        borderRadius:
                                        BorderRadius.circular(12.r),
                                      ),
                                      child: Center(
                                        child: dt == null
                                            ? const SizedBox()
                                            : Text(
                                          '${dt.day}',
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: isSel
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                            color: isSel
                                                ? Colors.white
                                                : AppColors.darkBlue,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),


                            BlocBuilder<ScheduleCubit, ScheduleState>(
                              builder: (_, state) {
                                if (state is ScheduleLoading) {
                                  return const Padding(
                                    padding: EdgeInsets.only(top: 16),
                                    child: Center(
                                        child:
                                        CircularProgressIndicator()),
                                  );
                                }
                                if (state is ScheduleError) {
                                  return Padding(
                                    padding: EdgeInsets.only(top: 16.h),
                                    child: Text(
                                      'Error: ${state.message}',
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 14.sp),
                                    ),
                                  );
                                }
                                if (state is ScheduleLoaded) {
                                  final evs = state.events;
                                  if (evs.isEmpty) {
                                    return Padding(
                                      padding:
                                      EdgeInsets.only(top: 16.h),
                                      child: Text(
                                        'dont have tasks for today',
                                        style: TextStyle(
                                            color: AppColors.t2,
                                            fontSize: 16.sp),
                                      ),
                                    );
                                  }
                                  return Column(
                                    children: evs.map((e) {
                                      return ListTile(
                                        leading: Icon(Icons.event,
                                            color: AppColors.purple),
                                        title: Text(e.course.name),
                                        subtitle: Text(
                                          '${e.section.name} • ${e.startTime} - ${e.endTime}',
                                          style: TextStyle(
                                              color: AppColors.t3),
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.purple),
        borderRadius: BorderRadius.circular(32.r),
      ),
      child: DropdownButton<String>(
        underline: const SizedBox(),
        value: value,
        items: items
            .map((v) => DropdownMenuItem(child: Text(v), value: v))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
