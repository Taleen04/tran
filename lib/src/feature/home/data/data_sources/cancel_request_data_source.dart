import 'dart:io';
import 'package:ai_transport/src/core/database/api/apiclient.dart';
import 'package:ai_transport/src/core/resources/api_constants.dart';
import 'package:ai_transport/src/feature/home/data/models/cancel_request_model.dart';
import 'package:ai_transport/src/feature/home/domain/entities/cancel_request_entity.dart';
import 'package:dio/dio.dart';

abstract class CancelRequestDataSource {
  Future<CancelRequestResponseEntity> cancelRequest({
    required int requestId,
    required List<File> evidencePhotos,
    required CancellationReason reason,
    String? notes,
  });
}

class CancelRequestDataSourceImpl implements CancelRequestDataSource {
  @override
  Future<CancelRequestResponseEntity> cancelRequest({
    required int requestId,
    required List<File> evidencePhotos,
    required CancellationReason reason,
    String? notes,
  }) async {
    try {
      // Create FormData for multipart request
      final formData = FormData();

      // Add evidence photos
      for (int i = 0; i < evidencePhotos.length; i++) {
        final file = evidencePhotos[i];
        formData.files.add(MapEntry(
          'photos[]',
          await MultipartFile.fromFile(
            file.path,
            filename: 'evidence_photo_$i.jpg',
          ),
        ));
      }

      // Add form fields
      formData.fields.add(MapEntry('reason', reason.value));
      if (notes != null && notes.isNotEmpty) {
        formData.fields.add(MapEntry('notes', notes));
      }

      // Send request
      final response = await ApiClient.dio.post(
        ApiConstants.cancelRequest(requestId),
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
      
      if (response.statusCode == 200) {
        final model = CancelRequestResponseModel.fromJson(response.data);
        return model.toEntity();
      } else {
        throw Exception('Failed to cancel request: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error cancelling request: $e');
    }
  }
}
