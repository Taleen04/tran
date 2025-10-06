import 'dart:developer';
import 'package:ai_transport/main.dart';
import 'package:ai_transport/src/core/database/api/apiclient.dart';
import 'package:ai_transport/src/core/database/cache/shared_pref_helper.dart';
import 'package:ai_transport/src/core/resources/api_constants.dart';
import 'package:ai_transport/src/feature/profile/data/models/online_status_model.dart';
import 'package:dio/dio.dart';

import '../models/profile_models.dart';

class OnlineStatusDataSource {
  Future<StaffProfileModel> getUserProfile() async {

    
    // إعدادات إعادة المحاولة
    const maxRetries = 3;
    const retryDelay = Duration(seconds: 2);
    
    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        log('محاولة تحديث حالة السائق - المحاولة $attempt من $maxRetries');

        final res = await ApiClient.dio.get(
          ApiConstants.userProfile,
        );

        if (res.statusCode == 200) {
          log('تم تحديث حالة السائق بنجاح');
         return StaffProfileModel.fromJson(res.data);

        } else {
          throw Exception('فشل في تحديث حالة السائق: ${res.statusCode}');
        }
      } on DioException catch (dioError) {
        log('خطأ في الاتصال - المحاولة $attempt: ${dioError.message}');
        
        // تحديد نوع الخطأ
        String errorMessage;
        switch (dioError.type) {
          case DioExceptionType.connectionTimeout:
            errorMessage = 'انتهت مهلة الاتصال بالخادم';
            break;
          case DioExceptionType.receiveTimeout:
            errorMessage = 'انتهت مهلة استقبال البيانات من الخادم';
            break;
          case DioExceptionType.sendTimeout:
            errorMessage = 'انتهت مهلة إرسال البيانات للخادم';
            break;
          case DioExceptionType.connectionError:
            errorMessage = 'خطأ في الاتصال بالخادم - تحقق من اتصال الإنترنت';
            break;
          case DioExceptionType.badResponse:
            errorMessage = 'استجابة خاطئة من الخادم: ${dioError.response?.statusCode}';
            break;
          case DioExceptionType.cancel:
            errorMessage = 'تم إلغاء الطلب';
            break;
          case DioExceptionType.unknown:
            errorMessage = 'خطأ غير معروف في الاتصال';
            break;
          default:
            errorMessage = 'خطأ في الاتصال: ${dioError.message}';
        }
        
        // إذا كانت المحاولة الأخيرة، أرسل الخطأ
        if (attempt == maxRetries) {
          throw Exception('فشل في تحديث حالة السائق بعد $maxRetries محاولات: $errorMessage');
        }
        
        // انتظار قبل المحاولة التالية
        log('انتظار ${retryDelay.inSeconds} ثانية قبل المحاولة التالية...');
        await Future.delayed(retryDelay);
        
      } catch (e) {
        log('خطأ عام في تحديث حالة السائق: $e');
        if (attempt == maxRetries) {
          throw Exception('خطأ في تحديث حالة السائق: $e');
        }
        await Future.delayed(retryDelay);
      }
    }
    
    // هذا السطر لن يتم الوصول إليه أبداً، لكن Dart يطلب return statement
    throw Exception('خطأ غير متوقع');
  }

  Future<OnlineStatusModel> updateOnlineStatus(bool onlineStatus, bool isOnline) async {
    final body = {'online_status': onlineStatus, 'is_online': isOnline};

    // إعدادات إعادة المحاولة
    const maxRetries = 3;
    const retryDelay = Duration(seconds: 2);

    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        log('محاولة تحديث حالة السائق - المحاولة $attempt من $maxRetries');

        final res = await ApiClient.dio.patch(
          ApiConstants.onlineStatus,
          data: body,
        );

        if (res.statusCode == 200) {
          log('تم تحديث حالة السائق بنجاح');
          SharedPrefHelper.setData(StorageKeys.current_status,onlineStatus);
         return OnlineStatusModel.fromJson(res.data);

        } else {
          throw Exception('فشل في تحديث حالة السائق: ${res.statusCode}');
        }
      } on DioException catch (dioError) {
        log('خطأ في الاتصال - المحاولة $attempt: ${dioError.message}');

        // تحديد نوع الخطأ
        String errorMessage;
        switch (dioError.type) {
          case DioExceptionType.connectionTimeout:
            errorMessage = 'انتهت مهلة الاتصال بالخادم';
            break;
          case DioExceptionType.receiveTimeout:
            errorMessage = 'انتهت مهلة استقبال البيانات من الخادم';
            break;
          case DioExceptionType.sendTimeout:
            errorMessage = 'انتهت مهلة إرسال البيانات للخادم';
            break;
          case DioExceptionType.connectionError:
            errorMessage = 'خطأ في الاتصال بالخادم - تحقق من اتصال الإنترنت';
            break;
          case DioExceptionType.badResponse:
            errorMessage = 'استجابة خاطئة من الخادم: ${dioError.response?.statusCode}';
            break;
          case DioExceptionType.cancel:
            errorMessage = 'تم إلغاء الطلب';
            break;
          case DioExceptionType.unknown:
            errorMessage = 'خطأ غير معروف في الاتصال';
            break;
          default:
            errorMessage = 'خطأ في الاتصال: ${dioError.message}';
        }

        // إذا كانت المحاولة الأخيرة، أرسل الخطأ
        if (attempt == maxRetries) {
          throw Exception('فشل في تحديث حالة السائق بعد $maxRetries محاولات: $errorMessage');
        }

        // انتظار قبل المحاولة التالية
        log('انتظار ${retryDelay.inSeconds} ثانية قبل المحاولة التالية...');
        await Future.delayed(retryDelay);

      } catch (e) {
        log('خطأ عام في تحديث حالة السائق: $e');
        if (attempt == maxRetries) {
          throw Exception('خطأ في تحديث حالة السائق: $e');
        }
        await Future.delayed(retryDelay);
      }
    }

    // هذا السطر لن يتم الوصول إليه أبداً، لكن Dart يطلب return statement
    throw Exception('خطأ غير متوقع');
  }

  Future<OnlineStatusModel> updateAvailableStatus(String availableStatus) async {
    final body = {'current_status': availableStatus};

    // إعدادات إعادة المحاولة
    const maxRetries = 3;
    const retryDelay = Duration(seconds: 2);

    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        log('محاولة تحديث حالة السائق - المحاولة $attempt من $maxRetries');

        final res = await ApiClient.dio.patch(
          ApiConstants.availableStatus,
          data: body,
        );

        if (res.statusCode == 200) {
          log('تم تحديث حالة السائق بنجاح');
          SharedPrefHelper.setData(StorageKeys.available_status,availableStatus);
         return OnlineStatusModel.fromJson(res.data);

        } else {
          throw Exception('فشل في تحديث حالة السائق: ${res.statusCode}');
        }
      } on DioException catch (dioError) {
        log('خطأ في الاتصال - المحاولة $attempt: ${dioError.message}');

        // تحديد نوع الخطأ
        String errorMessage;
        switch (dioError.type) {
          case DioExceptionType.connectionTimeout:
            errorMessage = 'انتهت مهلة الاتصال بالخادم';
            break;
          case DioExceptionType.receiveTimeout:
            errorMessage = 'انتهت مهلة استقبال البيانات من الخادم';
            break;
          case DioExceptionType.sendTimeout:
            errorMessage = 'انتهت مهلة إرسال البيانات للخادم';
            break;
          case DioExceptionType.connectionError:
            errorMessage = 'خطأ في الاتصال بالخادم - تحقق من اتصال الإنترنت';
            break;
          case DioExceptionType.badResponse:
            errorMessage = 'استجابة خاطئة من الخادم: ${dioError.response?.statusCode}';
            break;
          case DioExceptionType.cancel:
            errorMessage = 'تم إلغاء الطلب';
            break;
          case DioExceptionType.unknown:
            errorMessage = 'خطأ غير معروف في الاتصال';
            break;
          default:
            errorMessage = 'خطأ في الاتصال: ${dioError.message}';
        }

        // إذا كانت المحاولة الأخيرة، أرسل الخطأ
        if (attempt == maxRetries) {
          throw Exception('فشل في تحديث حالة السائق بعد $maxRetries محاولات: $errorMessage');
        }

        // انتظار قبل المحاولة التالية
        log('انتظار ${retryDelay.inSeconds} ثانية قبل المحاولة التالية...');
        await Future.delayed(retryDelay);

      } catch (e) {
        log('خطأ عام في تحديث حالة السائق: $e');
        if (attempt == maxRetries) {
          throw Exception('خطأ في تحديث حالة السائق: $e');
        }
        await Future.delayed(retryDelay);
      }
    }

    // هذا السطر لن يتم الوصول إليه أبداً، لكن Dart يطلب return statement
    throw Exception('خطأ غير متوقع');
  }
}
