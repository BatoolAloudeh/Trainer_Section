// lib/screen/Home/Settings/SettingsPage.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../Bloc/cubit/Settings/DarkMode/ChangeMode.dart';
import '../../../constant/ui/Colors/colors.dart';
import '../../../constant/ui/General constant/ConstantUi.dart'; // AppSidebar, SidebarItem

class SettingsPage extends StatefulWidget {
  static const routeName = '/settings';
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _lang = 'English';
  final List<String> _langs = ['English', 'Arabic'];

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
                      'Settings',
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
                            'Language:',
                            style: TextStyle(fontSize: 18.sp, color: AppColors.darkBlue),
                          ),
                          Spacer(),
                          DropdownButton<String>(
                            value: _lang,
                            icon: Icon(Icons.arrow_drop_down, color: AppColors.darkBlue),
                            items: _langs
                                .map((l) => DropdownMenuItem(
                              value: l,
                              child: Text(l, style: TextStyle(fontSize: 16.sp)),
                            ))
                                .toList(),
                            onChanged: (v) {
                              if (v == null) return;
                              setState(() => _lang = v);

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
                                'Dark Mode',
                                style: TextStyle(fontSize: 18.sp, color: AppColors.darkBlue),
                              ),
                              Spacer(),
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







//
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../Bloc/cubit/Settings/DarkMode/ChangeMode.dart';
//
// class SettingsScreen extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return SettingsScreenState();
//   }
// }
//
// class SettingsScreenState extends State<SettingsScreen> {
//   // Language _language = Language();
//   // List<String> _languages = ['Arabic', 'English'];
//   // String? selectedLanguage;
//   //
//   // @override
//   // void initState() {
//   //   super.initState();
//   //   _initLanguage();
//   // }
//   //
//   // void _initLanguage() async {
//   //   SharedPreferences pref = await SharedPreferences.getInstance();
//   //   String? savedLanguage = pref.getString(_language.languagee());
//   //
//   //   if (savedLanguage != null) {
//   //     _language.setLang(savedLanguage);
//   //     setState(() {
//   //       selectedLanguage = savedLanguage;
//   //     });
//   //   }
//   // }
//
//   // void _saveLanguage(String language) async {
//   //   SharedPreferences prefs = await SharedPreferences.getInstance();
//   //   await prefs.setString(_language.languagee(), language);
//   //   _language.setLang(language);
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Settings"
//             // _language.Setting()
//
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//
//             // خيار تبديل الوضع
//             ListTile(
//               leading: Icon(Icons.brightness_6),
//               // title: Text(_language.Toggle()),
//               trailing: BlocBuilder<ThemeCubit, ThemeMode>(
//                 builder: (context, themeMode) {
//                   return Switch(
//                     value: themeMode == ThemeMode.dark,
//                     onChanged: (value) {
//                       context.read<ThemeCubit>().toggle();
//                     },
//                   );
//                 },
//               ),
//             ),
//             Divider(),
//
//             // خيار تبديل اللغة
//             ListTile(
//               leading: Icon(Icons.language),
//               // title: Text(_language.ChangeLanguage()),
//               // subtitle: Text(selectedLanguage ?? 'Select a language'),
//               // trailing: DropdownButton<String>(
//               //   value: selectedLanguage,
//               //   underline: SizedBox(),
//               //   icon: Icon(Icons.arrow_drop_down),
//               //   items: _languages.map((lang) {
//               //     return DropdownMenuItem<String>(
//               //       value: lang,
//               //       child: Text(lang),
//               //     );
//               //   }).toList(),
//               //   onChanged: (String? newLang) {
//               //     if (newLang != null) {
//               //       setState(() {
//               //         selectedLanguage = newLang;
//               //       });
//               //       _saveLanguage(newLang); // حفظ اللغة
//               //     }
//               //   },
//               // ),
//             ),
//
//             Divider(),
//
//             // زر الحفظ
//             // Center(child:
//             // ElevatedButton(
//             //   onPressed: () {
//             //     // Navigator.pop(context, selectedLanguage); // إعادة اللغة المحددة إلى Dashboard
//             //   },
//             //   child:
//             //
//             //   Text(_language.Save()),
//             //   style: ElevatedButton.styleFrom(
//             //     backgroundColor: greenColor1,
//             //     foregroundColor: Colors.white,
//             //     padding: EdgeInsets.symmetric(horizontal: 200, vertical: 12),
//             //   ),
//             // )
//             //   ,
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }
