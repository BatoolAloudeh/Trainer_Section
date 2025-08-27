import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trainer_section/Bloc/cubit/Auth/logout.dart';
import 'package:trainer_section/Bloc/cubit/Home/Courses/showStudentsInSections.dart';
import 'package:trainer_section/Bloc/cubit/Profiles/Trainer.dart';
import 'package:trainer_section/constant/constantKey/key.dart';
import 'package:trainer_section/router/app-router.dart';
import 'package:trainer_section/screen/Settings/DarkMode/ChangeMode.dart';

import 'Bloc/cubit/Forum/AnswerCubit.dart';
import 'Bloc/cubit/Forum/general Bloc.dart';
import 'Bloc/cubit/Home/Courses/ShowCourses.dart';

import 'Bloc/cubit/Settings/DarkMode/ChangeMode.dart';
import 'Bloc/cubit/tests/create test.dart';
import 'localization/local_cubit/local_cubit.dart';
import 'network/local/cacheHelper.dart';
import 'network/remote/dioHelper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'dart:html' as html;
import 'package:flutter/foundation.dart' show kIsWeb;

import 'localization/app_localizations_setup.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

Future<void> _initFcmPreUI() async {
  final messaging = FirebaseMessaging.instance;
  final perm = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );
  if (perm.authorizationStatus != AuthorizationStatus.authorized) return;

  String? token;
  for (var i = 0; i < 3; i++) {
    try {
      token = await messaging.getToken(
        vapidKey:
            'BMUIu0ik_OZJ9r9n3GPXib5fouwP02aKUqHBPJZFio406nmC_henlk7OtEco9fc5xd7Q3q_tZM0RuP6oBBPqTPc',
      );
      if (token != null && token.isNotEmpty) break;
      await Future.delayed(const Duration(seconds: 1));
    } catch (_) {}
  }
  debugPrint('🔑 FCM Token (pre-UI): $token');

  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
    debugPrint('🔁 Token refreshed: $newToken');
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  DioHelper.init();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await _initFcmPreUI();

  if (kIsWeb) {
    usePathUrlStrategy(); // Without # in the link
  }

  runApp(
    ScreenUtilInit(
      designSize: const Size(1440, 1024),
      minTextAdapt: true,
      splitScreenMode: true,
      builder:
          (_, __) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => ThemeCubit()),
              BlocProvider(create: (_) => CoursesCubit()),
              BlocProvider(create: (_) => StudentsInSectionCubit()),
              BlocProvider(create: (_) => QuizCubit()),
              BlocProvider(create: (_) => ForumCubit()),
              BlocProvider(create: (_) => AnswerCubit()),
              BlocProvider(create: (_) => LogoutCubit()),
              BlocProvider(create: (_) => TrainerProfileCubit()),
              // ← أضِف مزوّد اللغة
              BlocProvider(create: (_) => LocaleCubit()),
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
    FirebaseMessaging.onMessage.listen((msg) async {
      final title =
          msg.notification?.title ?? msg.data['title'] ?? 'Notification';
      final body = msg.notification?.body ?? msg.data['body'] ?? '';

      if (kIsWeb) {
        try {
          if (html.Notification.permission != 'granted') {
            await html.Notification.requestPermission();
          }
          if (html.Notification.permission == 'granted') {
            html.Notification(title, body: body, icon: '/icons/Icon-192.png');
          }
        } catch (_) {}
      }
      debugPrint('📬 FG message: ${msg.messageId} | data=${msg.data}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        // ← لفّ MaterialApp بمحدد اللغة
        return BlocBuilder<LocaleCubit, Locale>(
          builder: (context, appLocale) {
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              title: 'Trainer Section',
              theme: AppThemes.light,
              darkTheme: AppThemes.dark,
              themeMode: themeMode,

              locale: appLocale,
              supportedLocales: AppLocalizationsSetup.supportedLocales,
              localizationsDelegates:
                  AppLocalizationsSetup.localizationsDelegates,
              localeResolutionCallback:
                  AppLocalizationsSetup.localeResolutionCallback,
              routerConfig: router,
            );
          },
        );
      },
    );
  }
}
