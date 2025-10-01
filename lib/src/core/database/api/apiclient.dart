import 'dart:developer';
import 'package:ai_transport/main.dart';
import 'package:ai_transport/src/core/database/cache/shared_pref_helper.dart';
import 'package:ai_transport/src/core/resources/api_constants.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiClient {
  static final Dio dio = Dio(BaseOptions(
    baseUrl: ApiConstants.baseUrl,
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
    sendTimeout: const Duration(seconds: 15),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ))
    ..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = SharedPrefHelper.getString(StorageKeys.token);
          if (token.isNotEmpty) {
            log('from interceptor ----- $token');
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          log('API Error: ${error.message}');
          log('Error Type: ${error.type}');
          log('Response Data: ${error.response?.data}');
          return handler.next(error);
        },
      ),
    )
    ..interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
      ),
    );
}


