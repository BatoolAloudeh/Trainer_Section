// lib/screens/profile/trainer_profile_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_network/image_network.dart';
import 'package:intl/intl.dart';
import '../../../Bloc/cubit/Profiles/Trainer.dart';
import '../../../Bloc/states/Profiles/Trainer.dart';
import '../../../constant/constantKey/key.dart';
import '../../../constant/ui/Colors/colors.dart';
import '../../../constant/ui/General constant/ConstantUi.dart';


class TrainerProfilePage extends StatefulWidget {
  final String token;
  final int idTrainer;
  const TrainerProfilePage({
    Key? key,
    required this.token,
    required this.idTrainer,
  }) : super(key: key);

  @override
  _TrainerProfilePageState createState() => _TrainerProfilePageState();
}

class _TrainerProfilePageState extends State<TrainerProfilePage> {
  late final TrainerProfileCubit _cubit;

  @override
  void initState() {
    super.initState();
    // fetch profile using the provided token
    _cubit = TrainerProfileCubit()..fetchProfile();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1440, 1024),
      builder: (_, __) => BlocProvider.value(
        value: _cubit,
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: Row(
            children: [
              const AppSidebar(selectedItem: SidebarItem.Profile),
              Expanded(
                child: BlocBuilder<TrainerProfileCubit, TrainerProfileState>(
                  builder: (ctx, state) {
                    if (state is TrainerProfileLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is TrainerProfileError) {
                      return Center(
                        child: Text(
                          state.message,
                          style: TextStyle(color: Colors.red, fontSize: 16.sp),
                        ),
                      );
                    }
                    if (state is TrainerProfileLoaded) {
                      final p = state.profile;
                      final photoUrl = (p.photo?.isNotEmpty == true)
                          ? '$BASE_URL${p.photo}'
                          : null;

                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            // ——— Bubble header with avatar ———
                            SizedBox(
                              height: 240.h,
                              width: double.infinity,
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  // 1) Soft bubbles in background
                                  Positioned(
                                    top: 20.h,
                                    left: 40.w,
                                    child: Container(
                                      width: 120.w,
                                      height: 120.w,
                                      decoration: BoxDecoration(
                                        color: AppColors.orange.withOpacity(0.2),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 80.h,
                                    right: 60.w,
                                    child: Container(
                                      width: 180.w,
                                      height: 180.w,
                                      decoration: BoxDecoration(
                                        color: AppColors.purple.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),

                                  Positioned(
                                    bottom: 20.h,
                                    left: 150.w,
                                    child: Container(
                                      width: 80.w,
                                      height: 80.w,
                                      decoration: BoxDecoration(
                                        color: AppColors.lightPurple.withOpacity(0.3),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),


                                  // 2) Centered avatar, fully visible
                                  Positioned(
                                    bottom: -80.h,
                                    left: (MediaQuery.of(context).size.width -
                                        400.w) /
                                        2, // center it inside Expanded
                                    child: CircleAvatar(
                                      radius: 150.r,
                                      backgroundColor: AppColors.w1,
                                      child: ClipOval(
                                        child: photoUrl != null
                                            ? ImageNetwork(
                                          image: photoUrl,
                                          width: 200,
                                          height: 200,
                                          fitAndroidIos: BoxFit.cover,
                                        )
                                            : Icon(Icons.person, size: 80.r),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 100.h),

                            // ——— Info Card ———
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24.w),
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                    vertical: 32.h, horizontal: 24.w),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).scaffoldBackgroundColor,
                                  borderRadius: BorderRadius.circular(12.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 6.r,
                                      offset: Offset(0, 4.h),
                                    )
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      p.name,
                                      style: TextStyle(
                                        fontSize: 26.sp,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.darkBlue,
                                      ),
                                    ),
                                    SizedBox(height: 4.h),

                                    SizedBox(height: 24.h),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      children: [
                                        _InfoIcon(Icons.email, p.email),
                                        _InfoIcon(Icons.phone, p.phone),
                                        _InfoIcon(
                                          Icons.calendar_today,
                                          DateFormat.yMMMd()
                                              .format(p.createdAt),
                                        ),
                                        _InfoIcon(Icons.person, p.gender),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            SizedBox(height: 32.h),

                            // ——— Experience & Specialization ———
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24.w),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: _DetailCard(
                                        title: 'Experience',
                                        value: p.experience),
                                  ),
                                  SizedBox(width: 16.w),
                                  Expanded(
                                    child: _DetailCard(
                                        title: 'Specialization',
                                        value: p.specialization),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 40.h),
                          ],
                        ),
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
    );
  }

  Widget _InfoIcon(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, color: AppColors.orange, size: 20.sp),
        SizedBox(width: 6.w),
        Text(label, style: TextStyle(fontSize: 14.sp, color: AppColors.t2)),
      ],
    );
  }
}

class _DetailCard extends StatelessWidget {
  final String title, value;
  const _DetailCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4.r,
            offset: Offset(0, 2.h),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkBlue)),
          SizedBox(height: 8.h),
          Text(value, style: TextStyle(fontSize: 14.sp, color: AppColors.t2)),
        ],
      ),
    );
  }
}
