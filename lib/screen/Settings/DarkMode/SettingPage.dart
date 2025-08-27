
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../Bloc/cubit/Settings/DarkMode/ChangeMode.dart';
import '../../../constant/ui/Colors/colors.dart';
import '../../../constant/ui/General constant/ConstantUi.dart';
import '../../../constant/ui/language1.dart';
import '../../../localization/local_cubit/local_cubit.dart'; // AppSidebar, SidebarItem

class SettingsPage extends StatefulWidget {
  static const routeName = '/settings';
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // نحتفظ بالقيمة الداخلية كـ "Arabic" أو "English" فقط للتحكم بالقيمة
  late String _lang;
  final List<String> _langs = ['English', 'Arabic'];

  @override
  void initState() {
    super.initState();
    final code = context.read<LocaleCubit>().state.languageCode;
    _lang = (code == 'ar') ? 'Arabic' : 'English';
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1440, 1024),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) => Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Row(
          children: [
            AppSidebar(selectedItem: SidebarItem.settings),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)?.translate("settings") ?? "Settings",
                      style: TextStyle(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkBlue,
                      ),
                    ),
                    SizedBox(height: 32.h),

                    // **** Language Selection ****
                    Container(
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
                            AppLocalizations.of(context)?.translate("language") ?? "Language",
                            style: TextStyle(fontSize: 18.sp, color: AppColors.darkBlue),
                          ),
                          const Spacer(),
                          DropdownButton<String>(
                            value: _lang,
                            icon: Icon(Icons.arrow_drop_down, color: AppColors.darkBlue),
                            // نعرض النصوص مترجمة داخل العناصر
                            items: _langs.map((l) {
                              final translated = l == 'Arabic'
                                  ? (AppLocalizations.of(context)?.translate("arabic") ?? "Arabic")
                                  : (AppLocalizations.of(context)?.translate("english") ?? "English");
                              return DropdownMenuItem(
                                value: l,
                                child: Text(translated, style: TextStyle(fontSize: 16.sp)),
                              );
                            }).toList(),
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
                        ],
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // **** Theme Mode ****
                    BlocBuilder<ThemeCubit, ThemeMode>(
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
                                AppLocalizations.of(context)?.translate("Dark Mode") ?? "Dark Mode",
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
