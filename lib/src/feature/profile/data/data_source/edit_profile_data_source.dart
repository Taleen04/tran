import 'dart:developer';
import 'dart:io';
import 'package:ai_transport/src/core/database/api/apiclient.dart';
import 'package:ai_transport/src/core/resources/api_constants.dart';
import 'package:dio/dio.dart';

class EditProfileDataSource {



  Future<Map<String, dynamic>> uploadImagePhoto(File imageFile) async {
  try {
    FormData formData = FormData.fromMap({
      'photo': await MultipartFile.fromFile(imageFile.path),
      
    });

    final response = await ApiClient.dio.post(
      ApiConstants.changePhoto,
      data: formData,
      // Optional: Dio automatically sets this with FormData
      options: Options(headers: {
        'Content-Type': 'multipart/form-data',
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return {
        'success': true,
        'message': 'Profile photo updated successfully',
        'data': response.data,
      };
    } else {
      return {
        'success': false,
        'message': 'Unexpected response from server.',
        'data': response.data,
      };
    }
  } catch (e) {
    // Logging the error
    log('Error uploading photo: $e');
    return {
      'success': false,
      'message': 'Profile photo not uploaded. Error: $e',
    };
  }
}

static Future<Map<String, dynamic>> uploadIdCardImage(File imageFile) async {
    try {
      FormData formData = FormData.fromMap({
      'id_card': await MultipartFile.fromFile(imageFile.path),
      
    });

      final response = await ApiClient.dio.post(
        ApiConstants.changePhoto,
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'data': response.data,
          'message': 'تم رفع صورة الهوية بنجاح',
        };
      } else {
        return {
          'success': false,
          'error': 'فشل في رفع صورة الهوية: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {'success': false, 'error': 'خطأ في رفع صورة الهوية: $e'};
    }
  }

  /// رفع صورة عدم المحكومية
  static Future<Map<String, dynamic>> uploadUngovernedImage(
    File imageFile,
  ) async {
    try {
       FormData formData = FormData.fromMap({
      'ungovered_photo': await MultipartFile.fromFile(imageFile.path),
      
    });


      final response = await ApiClient.dio.post(
        ApiConstants.changePhoto,
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'data': response.data,
          'message': 'تم رفع صورة عدم المحكومية بنجاح',
        };
      } else {
        return {
          'success': false,
          'error': 'فشل في رفع صورة عدم المحكومية: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {'success': false, 'error': 'خطأ في رفع صورة عدم المحكومية: $e'};
    }
  }


static Future<Map<String, dynamic>> carLicens(
    File imageFile,
  ) async {
    try {
       FormData formData = FormData.fromMap({
      'driver_license': await MultipartFile.fromFile(imageFile.path),
      
    });

      final response = await ApiClient.dio.post(
        ApiConstants.changePhoto,
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'data': response.data,
          'message': 'تم رفع صورة الرخصة بنجاح',
        };
      } else {
        return {
          'success': false,
          'error': 'فشل في رفع صورة الرخصة: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {'success': false, 'error': 'خطأ في رفع صورة الرخصة : $e'};
    }
  }


  
  Future<bool> updateProfile(Map<String, dynamic> body) async {
    try {
      final res = await ApiClient.dio.put(
        ApiConstants.editProfile,
        data: body,
      );

      if (res.statusCode == 200) {
        return true;
      } else {
        log('Failed to update profile: ${res.statusCode}');
        return false;
      }
    } catch (e) {
      log('Error updating profile: $e');
      return false;
    }
  } 
}