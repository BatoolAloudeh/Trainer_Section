//
// import 'package:bloc/bloc.dart';
// import 'package:dio/dio.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
//
// import '../../../constant/constantKey/key.dart';
// import '../../../constant/endPoint/endPoints.dart';
// import '../../../models/Auth/Login.dart';
// import '../../../network/local/cacheHelper.dart';
// import '../../../network/remote/dioHelper.dart';
// import '../../states/Auth/Login.dart';
//
//
// class LoginCubit extends Cubit<LoginState> {
//   LoginCubit() : super(LoginInitial());
//   Future<void> login({
//     required String email,
//     required String password,
//     // required String fcmToken,
//   }) async {
//     emit(LoginLoading());
//     String fcmToken = await _getDeviceToken();
//     try {
//       final response = await DioHelper.postData(
//         url: LOGIN,
//         data: {
//           'email': email,
//           'password': password,
//           'fcm_token': fcmToken,
//         },
//         headers: {},
//       );
//
//       print('deviceKey= $fcmToken');
//       final data = response.data as Map<String, dynamic>;
//
//
//       if (data.containsKey('AccessToken')) {
//         final model = LoginModel.fromJson(data);
//         await CacheHelper.saveData(
//           key: TOKENKEY,
//           value: model.accessToken!.accessToken,
//         );
//         emit(LoginSuccess(model.accessToken!));
//         return;
//       }
//
//       if (fcmToken != null) {
//         await CacheHelper.saveData(key: 'fcm_token', value: fcmToken);
//       }
//       emit(LoginFailure(
//         'There is an error in either the email or the password. Please check and try again.',
//       ));
//     } on DioError catch (err) {
//       final d = err.response?.data;
//       if (d is Map<String, dynamic>) {
//
//         if (d.containsKey('Message') &&
//             (d['Message'] as String).toLowerCase().trim() ==
//                 'your account not verified') {
//           emit(LoginNotVerified());
//           return;
//         }
//
//         if (d.containsKey('email')) {
//           final e = d['email'];
//           final msg = e is List && e.isNotEmpty ? e.first.toString() : e.toString();
//           emit(LoginFailure(msg));
//           return;
//         }
//       }
//
//       emit(LoginFailure(
//         'There is an error in either the email or the password. Please check and try again.',
//       ));
//     } catch (_) {
//       emit(LoginFailure(
//         'There is an error in either the email or the password. Please check and try again.',
//       ));
//     }
//   }
//   Future<String> _getDeviceToken() async {
//     FirebaseMessaging messaging = FirebaseMessaging.instance;
//     String? token = await messaging.getToken();
//     return token ?? 'unknown_token';
//   }
//
// }













import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../../../constant/constantKey/key.dart';
import '../../../constant/endPoint/endPoints.dart';
import '../../../models/Auth/Login.dart';
import '../../../network/local/cacheHelper.dart';
import '../../../network/remote/dioHelper.dart';
import '../../states/Auth/Login.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(LoginLoading());

    final fcmToken = await _getDeviceToken(); // ✅ اجلب التوكن من هنا فقط

    try {
      final response = await DioHelper.postData(
        url: LOGIN,
        data: {
          'email': email,
          'password': password,
          'fcm_token': fcmToken, // ✅ أرسل التوكن للسيرفر
        },
        headers: {},
      );

      print('deviceKey= $fcmToken');

      final data = response.data as Map<String, dynamic>;

      if (data.containsKey('AccessToken')) {
        final model = LoginModel.fromJson(data);

        await CacheHelper.saveData(
          key: TOKENKEY,
          value: model.accessToken!.accessToken,
        );

        // خزّن التوكن للاستخدام لاحقًا إذا تحب
        if (fcmToken.isNotEmpty) {
          await CacheHelper.saveData(key: 'fcm_token', value: fcmToken);
        }

        emit(LoginSuccess(model.accessToken!));
        return;
      }

      emit(LoginFailure(
        'There is an error in either the email or the password. Please check and try again.',
      ));
    } on DioError catch (err) {
      final d = err.response?.data;
      if (d is Map<String, dynamic>) {
        if (d.containsKey('Message') &&
            (d['Message'] as String).toLowerCase().trim() ==
                'your account not verified') {
          emit(LoginNotVerified());
          return;
        }

        if (d.containsKey('email')) {
          final e = d['email'];
          final msg = e is List && e.isNotEmpty ? e.first.toString() : e.toString();
          emit(LoginFailure(msg));
          return;
        }
      }

      emit(LoginFailure(
        'There is an error in either the email or the password. Please check and try again.',
      ));
    } catch (_) {
      emit(LoginFailure(
        'There is an error in either the email or the password. Please check and try again.',
      ));
    }
  }

  /// ✅ يستخدم vapidKey على الويب + 3 محاولات خفيفة إذا رجع null
  Future<String> _getDeviceToken() async {
    final messaging = FirebaseMessaging.instance;

    // تأكد أن الإذن مأخوذ مسبقًا (أنت فعليًا طلبته في main/index.html)
    // ممكن تضيف هنا سطر طلب الإذن كنسخة احتياطية:
    await messaging.requestPermission(alert: true, badge: true, sound: true);

    String? token;
    for (var i = 0; i < 3; i++) {
      try {
        if (kIsWeb) {
          token = await messaging.getToken(
            vapidKey:
            'BMUIu0ik_OZJ9r9n3GPXib5fouwP02aKUqHBPJZFio406nmC_henlk7OtEco9fc5xd7Q3q_tZM0RuP6oBBPqTPc',
          );
        } else {
          token = await messaging.getToken();
        }
        if (token != null && token.isNotEmpty) break;
        await Future.delayed(const Duration(milliseconds: 800));
      } catch (_) {}
    }
    return token ?? '';
  }
}
