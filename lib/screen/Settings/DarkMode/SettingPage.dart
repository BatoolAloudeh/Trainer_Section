
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Bloc/cubit/Settings/DarkMode/ChangeMode.dart';
import '../../../localization/local_cubit/local_cubit.dart';

import '../../../constant/ui/Colors/colors.dart';
import '../../../constant/ui/General constant/ConstantUi.dart';

import '../../../localization/app_localizations.dart' as loc;
import '../../../constant/ui/language1.dart' hide AppLocalizations;

class SettingsPage extends StatefulWidget {
  static const routeName = '/settings';
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late String _lang; // 'Arabic' أو 'English'
  final List<String> _langs = ['English', 'Arabic'];

  @override
  void initState() {
    super.initState();
    final code = context.read<LocaleCubit>().state.languageCode;
    _lang = (code == 'ar') ? 'Arabic' : 'English';
  }

  @override
  Widget build(BuildContext context) {
    // نراقب تغيّر اللغة كي يُعاد بناء الواجهة
    context.watch<LocaleCubit>();

    // ✅ المترجم الجاهز عبر الـ delegate (لا تنشئه يدويًا)
    final tr = loc.AppLocalizations.of(context).translate;

    return ScreenUtilInit(
      designSize: const Size(1440, 1024),
      minTextAdapt: true,
      builder: (_, __) => Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Row(
          children: [
            const AppSidebar(selectedItem: SidebarItem.settings),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tr('settings'),
                      style: TextStyle(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkBlue,
                      ),
                    ),
                    SizedBox(height: 32.h),

                    _LanguageCard(
                      tr: tr,
                      value: _lang,
                      onChanged: (v) {
                        if (v == null) return;
                        setState(() => _lang = v);
                        if (v == 'Arabic') {
                          context.read<LocaleCubit>().toArabic();
                        } else {
                          context.read<LocaleCubit>().toEnglish();
                        }
                      },
                    ),

                    SizedBox(height: 24.h),

                    _ThemeCard(tr: tr),
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

class _LanguageCard extends StatelessWidget {
  final String Function(String) tr;
  final String value;
  final ValueChanged<String?> onChanged;

  const _LanguageCard({
    Key? key,
    required this.tr,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400.w,
      padding: EdgeInsets.all(24.w),
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
      child: Row(
        children: [
          Icon(Icons.language, color: AppColors.purple, size: 28.sp),
          SizedBox(width: 16.w),
          Text(
            tr('language'),
            style: TextStyle(fontSize: 18.sp, color: AppColors.darkBlue),
          ),
          const Spacer(),
          DropdownButton<String>(
            value: value,
            underline: const SizedBox(),
            icon: Icon(Icons.arrow_drop_down, color: AppColors.darkBlue),
            items: const ['English', 'Arabic']
                .map(
                  (l) => DropdownMenuItem(
                value: l,
                child: Text(l == 'Arabic' ? 'العربية' : 'English'),
              ),
            )
                .toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _ThemeCard extends StatelessWidget {
  final String Function(String) tr;
  const _ThemeCard({Key? key, required this.tr}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, mode) {
        final isDark = mode == ThemeMode.dark;
        return Container(
          width: 400.w,
          padding: EdgeInsets.all(24.w),
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
          child: Row(
            children: [
              Icon(
                isDark ? Icons.dark_mode : Icons.light_mode,
                color: AppColors.purple,
                size: 28.sp,
              ),
              SizedBox(width: 16.w),
              Text(
                tr('Dark Mode'),
                style: TextStyle(fontSize: 18.sp, color: AppColors.darkBlue),
              ),
              const Spacer(),
              Switch(
                value: isDark,
                activeColor: AppColors.purple,
                onChanged: (_) => context.read<ThemeCubit>().toggle(),
              ),
            ],
          ),
        );
      },
    );
  }
}

