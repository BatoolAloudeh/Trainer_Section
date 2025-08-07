
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trainer_section/Bloc/cubit/Home/Courses/showStudentsInSections.dart';
import 'package:trainer_section/Bloc/cubit/Profiles/Trainer.dart';
import 'package:trainer_section/constant/constantKey/key.dart';
import 'package:trainer_section/screen/Auth/Login.dart';
import 'package:trainer_section/screen/Home/Courses/MainPage/ShowCourses.dart';
import 'package:trainer_section/screen/Settings/DarkMode/ChangeMode.dart';
import 'package:trainer_section/screen/Settings/DarkMode/SettingPage.dart';
//
import 'Bloc/cubit/Forum/AnswerCubit.dart';
import 'Bloc/cubit/Forum/general Bloc.dart';
import 'Bloc/cubit/Home/Courses/Files/upload.dart';
import 'Bloc/cubit/Home/Courses/ShowCourses.dart';

import 'Bloc/cubit/Settings/DarkMode/ChangeMode.dart';
import 'Bloc/cubit/tests/create test.dart';
import 'network/local/cacheHelper.dart';
import 'network/remote/dioHelper.dart';
import 'constant/ui/Colors/colors.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   // init local storage & dio
//   await CacheHelper.init();
//   DioHelper.init();
//
//   runApp(
//     ScreenUtilInit(
//       designSize: const Size(1440, 1024),
//       minTextAdapt: true,
//       splitScreenMode: true,
//       builder: (_, __) => MultiBlocProvider(
//         providers: [
//           // 1) ThemeCubit MUST be first, so that MaterialApp can read it
//           BlocProvider(create: (_) => ThemeCubit()),
//
//           // 2) your other cubits:
//           BlocProvider(create: (_) => CoursesCubit()),
//           BlocProvider(create: (_) => StudentsInSectionCubit()),
//           BlocProvider(create: (_) => QuizCubit()),
//           BlocProvider(create: (_) => ForumCubit()),
//           BlocProvider(create: (_) => AnswerCubit()),
//           BlocProvider(create: (_) => TrainerProfileCubit()),
//         ],
//         child: const MyApp(),
//       ),
//     ),
//   );
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     // Listen to ThemeMode changes
//     return BlocBuilder<ThemeCubit, ThemeMode>(
//       builder: (context, themeMode) {
//         // read saved token/profile
//         final token     = CacheHelper.getData(key: TOKENKEY)      as String?;
//         final trainerId = CacheHelper.getData(key: 'trainer_id') as int?;
//
//         return MaterialApp(
//           debugShowCheckedModeBanner: false,
//           title: 'Trainer Section',
//
//           // Use the AppThemes defined in app_themes.dart
//           theme: AppThemes.light,
//           darkTheme: AppThemes.dark,
//           themeMode: themeMode,
//
//           // initial route depends on login
//           home: (token != null && trainerId != null)
//               ? CoursesDashboard(token: token, idTrainer: trainerId)
//               :  LoginScreen(),
//
//           routes: {
//             SettingsPage.routeName: (_) => const SettingsPage(),
//           },
//         );
//       },
//     );
//   }
// }






import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
//

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  DioHelper.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ScreenUtilInit(
      designSize: const Size(1440,1024),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_,__) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => ThemeCubit()),
          BlocProvider(create: (_) => CoursesCubit()),
          BlocProvider(create: (_) => StudentsInSectionCubit()),
          BlocProvider(create: (_) => QuizCubit()),
          BlocProvider(create: (_) => ForumCubit()),
          BlocProvider(create: (_) => AnswerCubit()),
          BlocProvider(create: (_) => TrainerProfileCubit()),


        ],
        child: const RootApp(),
      ),
    ),
  );
}

class RootApp extends StatefulWidget {
  const RootApp({Key? key}) : super(key: key);
  @override
  State<RootApp> createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  @override
  void initState() {
    super.initState();
    _setupFCM();
  }

  Future<void> _setupFCM() async {
    final messaging = FirebaseMessaging.instance;

    // طلب إذن الإشعارات
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      debugPrint('🚫 Permission denied');
      return;
    }

    // جلب الـ token
    try {
      final token = await messaging.getToken(
        vapidKey: 'BMUIu0ik_OZJ9r9n3GPXib5fouwP02aKUqHBPJZFio406nmC_henlk7OtEco9fc5xd7Q3q_tZM0RuP6oBBPqTPc',
      );
      debugPrint('🔑 FCM Token: $token');
    } catch (e) {
      debugPrint('❌ FCM token error: $e');
    }

    // استماع للرسائل عند الـ foreground
    FirebaseMessaging.onMessage.listen((msg) {
      debugPrint('📬 Message: ${msg.notification}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit,ThemeMode>(
      builder:(context,themeMode){
        final token     = CacheHelper.getData(key: TOKENKEY)      as String?;
        final trainerId = CacheHelper.getData(key: 'trainer_id') as int?;

        return MaterialApp(
          debugShowCheckedModeBanner:false,
          title:'Trainer Section',
          theme:AppThemes.light,
          darkTheme:AppThemes.dark,
          themeMode:themeMode,
          home:(token!=null&&trainerId!=null)
              ?CoursesDashboard(token:token,idTrainer:trainerId)
              :LoginScreen(),
          routes:{ SettingsPage.routeName:(_)=>const SettingsPage() },
        );
      },
    );
  }
}





