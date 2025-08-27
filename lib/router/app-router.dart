import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:trainer_section/Bloc/cubit/Auth/Login.dart';
import 'package:trainer_section/router/route-paths.dart';
import 'package:trainer_section/screen/Auth/Login.dart';
import 'package:trainer_section/screen/Auth/Verification.dart';
import 'package:trainer_section/screen/Auth/logout.dart';
import 'package:trainer_section/screen/Auth/resetPassword.dart';
import 'package:trainer_section/screen/Calendar/calendar.dart';
import 'package:trainer_section/screen/Home/Courses/MainPage/ShowCourses.dart';
import 'package:trainer_section/screen/Home/Profiles/Trainer.dart';
import 'package:trainer_section/screen/Settings/DarkMode/SettingPage.dart';
import 'package:trainer_section/screen/notification/notification.dart';

import 'route_guards.dart';

final loginCubit = LoginCubit();

final router = GoRouter(
  refreshListenable: GoRouterRefreshStream(loginCubit.stream),
  redirect: guardRedirect, // ← uses matchedLocation/uri now
  errorBuilder:
      (context, state) =>
          const Scaffold(body: Center(child: Text('404 - Page not found'))),
  routes: [
    GoRoute(
      path: RoutePaths.login,
      builder:
          (context, state) =>
              BlocProvider.value(value: loginCubit, child: const LoginScreen()),
    ),
    GoRoute(
      path: RoutePaths.checkCode,
      builder: (context, state) => const CheckCodeScreen(),
    ),
    GoRoute(
      path: RoutePaths.courses,
      builder: (context, state) => const CoursesDashboard(),
    ),
    ShellRoute(
      builder: (context, state, child) => Scaffold(body: child),
      routes: [
        GoRoute(
          path: RoutePaths.profile,
          builder: (context, state) => const TrainerProfilePage(),
        ),
        GoRoute(
          path: RoutePaths.profileSettings,
          builder: (context, state) => const PrivacySecurityPage(),
        ),
      ],
    ),
    GoRoute(
      path: RoutePaths.calendar,
      builder: (context, state) => const CalendarPage(),
    ),
    GoRoute(
      path: RoutePaths.notifications,
      builder: (context, state) => const NotificationsPage(),
    ),
    GoRoute(
      path: RoutePaths.settings,
      builder: (context, state) => const SettingsPage(),
    ),
    GoRoute(
      path: RoutePaths.logout,
      builder: (context, state) => const LogoutPage(),
    ),
    // ShellRoute(
    //   builder:
    //       (context, state, child) => Scaffold(
    //         appBar: AppBar(title: const Text('My App')),
    //         body: child,
    //       ),
    // routes: [
    // GoRoute(
    //   path: RoutePaths.projects,
    //   builder: (context, state) => const ProjectListPage(),
    //   routes: [
    //     GoRoute(
    //       path: ':id',
    //       builder: (context, state) {
    //         final id = state.pathParameters['id']!;
    //         final tab = state.uri.queryParameters['tab'];
    //         return ProjectDetailsPage(id: id, initialTab: tab);
    //       },
    //     ),
    //   ],
    // ),
    // GoRoute(
    //   path: RoutePaths.settings,
    //   builder: (context, state) {
    //     final tab = state.uri.queryParameters['tab'] ?? 'profile';
    //     return SettingsPage(initialTab: tab);
    //   },
    // ),
    // ],
    // ),
  ],
);
