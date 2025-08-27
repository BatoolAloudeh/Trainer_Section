// lib/routes/route_guards.dart
import 'dart:async';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart'; // <-- for BuildContext
import 'package:go_router/go_router.dart';
import 'package:trainer_section/router/route-paths.dart';

import '../constant/constantKey/key.dart';
import '../network/local/cacheHelper.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _sub = stream.listen((_) {
      SchedulerBinding.instance.addPostFrameCallback((_) => notifyListeners());
    });
  }

  late final StreamSubscription _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

String? _postLoginRedirect;

bool _hasToken() {
  final token = CacheHelper.getData(key: TOKENKEY);
  return token != null && token.toString().isNotEmpty;
}

bool _isPublic(String matchedLocation) {
  return matchedLocation == RoutePaths.login;
}

FutureOr<String?> guardRedirect(BuildContext context, GoRouterState state) {
  final matched = state.matchedLocation; // e.g. "/login"
  final fullUrl = state.uri.toString(); // e.g. "/projects/42?tab=files"
  final goingToLogin = matched == RoutePaths.login;
  final loggedIn = _hasToken();

  if (!loggedIn && !_isPublic(matched)) {
    _postLoginRedirect = fullUrl;
    return RoutePaths.login;
  }

  if (loggedIn && goingToLogin) {
    final target = _postLoginRedirect ?? RoutePaths.courses;
    _postLoginRedirect = null;
    return target;
  }

  return null;
}
