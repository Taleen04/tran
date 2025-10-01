import 'package:ai_transport/main.dart';
import 'package:ai_transport/src/core/database/api/apiclient.dart';
import 'package:ai_transport/src/core/database/cache/shared_pref_helper.dart';
import 'package:ai_transport/src/core/resources/api_constants.dart';
import 'package:ai_transport/src/feature/home/data/models/location_status_model.dart';
import 'package:ai_transport/src/feature/home/domain/entities/location_status_entity.dart';

class LocationStatusDataSource {
  Future<LocationStatusModel> fetchLocationStatus(LocationStatusEnum status) async {
    final body={'location_status':status.toApiValue()};
    try {
      final res = await ApiClient.dio.patch(ApiConstants.locationStatus,data: body);
       
      if (res.statusCode == 200) {
SharedPrefHelper.setData(StorageKeys.locationStaff, status.toApiValue());
        return LocationStatusModel.fromJson(res.data);
      } else {
        throw Exception("Failed to fetch location status: ${res.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching location status: $e");
    }
  }


  
  
}


