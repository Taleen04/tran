import 'package:ai_transport/src/feature/home/data/data_sources/location_status_data_source.dart';
import 'package:ai_transport/src/feature/home/domain/entities/location_status_entity.dart';

class LocationStatusRepo {
  final LocationStatusDataSource locationStatusDataSource;

  LocationStatusRepo({required this.locationStatusDataSource});

  Future<LocationStatusEntity>getLocationStatus(LocationStatusEnum status)async {
  
  final  response=await locationStatusDataSource.fetchLocationStatus(status);
     
  
  return response;
  }

}