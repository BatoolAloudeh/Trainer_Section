import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trainer_section/constant/ui/General%20constant/ConstantUi.dart';
import 'package:trainer_section/screen/Auth/Login.dart';

import '../../Bloc/cubit/Auth/logout.dart';
import '../../Bloc/states/Auth/logout.dart';
import '../../constant/constantKey/key.dart';
import '../../constant/ui/Colors/colors.dart';

import '../../localization/app_localizations.dart';
import '../../network/local/cacheHelper.dart';

import 'dart:ui';

class LogoutPage extends StatelessWidget {
  const LogoutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LogoutCubit, LogoutState>(
      listener: (context, state) {
        if (state is LogoutSuccess) {
        navigateTo(context, LoginScreen());
        } else if (state is LogoutFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is LogoutLoading;

        return Scaffold(
          backgroundColor: Colors.white, // خلفية بيضاء للصفحة
          body: Center(
            child: Container(
              width: 340.w,
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 18.r,
                    offset: Offset(0, 10.h),
                  ),
                ],
                border: Border.all(color: AppColors.purple.withOpacity(0.10)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.logout, size: 42.sp, color: AppColors.purple),
                  SizedBox(height: 12.h),
                  Text(
                    AppLocalizations.of(context)?.translate("logout") ?? "Logout"
                    ,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.purple,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    AppLocalizations.of(context)?.translate("logout_message") ?? "To continue, please press logout."
               ,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13.sp, color: Colors.black54, height: 1.3),
                  ),
                  SizedBox(height: 22.h),
                  SizedBox(
                    width: double.infinity,
                    height: 46.h,
                    child: ElevatedButton(
                      // ✅ مباشرة: استدعِ تسجيل الخروج بدون أي Dialog
                      onPressed: isLoading ? null : () => context.read<LogoutCubit>().logout(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.purple,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                        elevation: 0,
                      ),
                      child: isLoading
                          ? SizedBox(
                        width: 18.r,
                        height: 18.r,
                        child: const CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                          : Text(
                        AppLocalizations.of(context)?.translate("logout") ?? "Logout"
                        ,

                        style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}