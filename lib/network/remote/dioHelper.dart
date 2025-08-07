
import 'package:dio/dio.dart';

import '../../constant/constantKey/key.dart';
import '../local/cacheHelper.dart';

class DioHelper {
  static late Dio dio;

  static   init() {
    dio = Dio(
      BaseOptions(
        baseUrl: BASE_URL_API,
        receiveDataWhenStatusError: true,
      ),
    );




    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        const String LOGIN = 'https://api.dev4.gomaplus.tech/api/loginEmployee';
        if (options.path != LOGIN) {
          final token = CacheHelper.getData(key: TOKENKEY);
          // if (token != null) {
            options.headers['authorization'] = 'Bearer $token';
          // }
          options.headers['Connection'] = 'keep-alive';
          options.headers['Accept'] = '*/*';
        }
        print(options.headers);
        return handler.next(options);
      },    ));}
  //     onError: (DioError error, handler) async {
  //       if (error.response?.statusCode == 401) {
  //         try {
  //           await refreshAccessToken();
  //
  //           final newAccessToken = CacheHelper.getData(key: "ACCESS_TOKEN");
  //           if (newAccessToken != null) {
  //             error.requestOptions.headers['authorization'] =
  //             'Bearer $newAccessToken';
  //             final opts = error.requestOptions;
  //
  //             final retryResponse = await dio.request(
  //               opts.path,
  //               options: Options(
  //                 method: opts.method,
  //                 headers: opts.headers,
  //               ),
  //               data: opts.data,
  //               queryParameters: opts.queryParameters,
  //             );
  //             return handler.resolve(retryResponse);
  //           }
  //         } catch (refreshError) {
  //           print("Token refresh failed: $refreshError");
  //           CacheHelper.deleteData(key: "ACCESS_TOKEN");
  //           CacheHelper.deleteData(key: "REFRESH_TOKEN");
  //           return handler.reject(error);
  //         }
  //       }
  //       return handler.next(error);
  //     },
  //   ));
  // }
  //
  // static Future<void> refreshAccessToken() async {
  //   final refreshToken = CacheHelper.getData(key: "REFRESH_TOKEN");
  //
  //   if (refreshToken != null) {
  //     try {
  //       final response = await dio.post(
  //         '/auth/user/refresh',
  //         options: Options(
  //           headers: {
  //             'Authorization': 'Bearer $refreshToken',
  //           },
  //         ),
  //       );
  //
  //       final newAccessToken = response.data['token'];
  //       if (newAccessToken != null) {
  //         await CacheHelper.saveData(key: "ACCESS_TOKEN", value: newAccessToken);
  //       }
  //     } catch (error) {
  //       print("Failed to refresh token: $error");
  //       throw Exception("Refresh Token failed");
  //     }
  //   } else {
  //     throw Exception("No Refresh Token available");
  //   }
  // }


  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  }) async {
    return await dio.get(
      url,
      queryParameters: query,
      options: Options(
        headers: headers,
      ),
    );
  }

  static Future<Response> postData({
    required String url,
    required Map<String, dynamic> data,
    Map<String, dynamic>? query,
    Options? options,
    required Map<String, String> headers,
  }) async {
    return await dio.post(url,
        data: data, queryParameters: query, options: options);
  }

  static Future<Response> postFormData({
    required String url,
    required FormData formData,
    Map<String, dynamic>? query,
    Options? options,
  }) async {
    return await dio.post(url,
        data: formData, queryParameters: query, options: options);
  }

  static Future<Response> putData({
    required String url,
    required Map<String, dynamic> data,
    Map<String, dynamic>? query,
    Options? options,
    Map<String, dynamic>? headers,
  }) async {
    return await dio.put(url,
        data: data, queryParameters: query, options: options);
  }


  static Future<Response> deleteData({
    required String url,
    Map<String, dynamic>? query,
    Options? options,
  }) async {
    return await dio.delete(url, queryParameters: query, options: options);
  }


}
