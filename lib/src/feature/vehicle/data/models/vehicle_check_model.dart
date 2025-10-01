import 'package:ai_transport/src/feature/vehicle/domain/entities/vehicle_check_entity.dart';

class VehicleCheckModel extends VehicleCheckEntity {
  VehicleCheckModel({
    required super.exists,
    super.vehicle,
  });

  factory VehicleCheckModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    
    return VehicleCheckModel(
      exists: data['exists'] ?? false,
      vehicle: data['vehicle'] != null 
          ? VehicleInfoModel.fromJson(data['vehicle'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': {
        'exists': exists,
        'vehicle': vehicle != null ? (vehicle as VehicleInfoModel).toJson() : null,
      },
    };
  }

  VehicleCheckEntity toEntity() => this;
}

class VehicleInfoModel extends VehicleInfoEntity {
  VehicleInfoModel({
    required super.type,
    required super.name,
    required super.color,
    required super.make,
    required super.model,
    required super.year,
    required super.isAssigned,
    required super.assignedToCurrentDriver,
  });

  factory VehicleInfoModel.fromJson(Map<String, dynamic> json) {
    return VehicleInfoModel(
      type: json['type'] ?? '',
      name: json['name'] ?? '',
      color: json['color'] ?? '',
      make: json['make'] ?? '',
      model: json['model'] ?? '',
      year: json['year'] ?? 0,
      isAssigned: json['is_assigned'] ?? false,
      assignedToCurrentDriver: json['assigned_to_current_driver'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'name': name,
      'color': color,
      'make': make,
      'model': model,
      'year': year,
      'is_assigned': isAssigned,
      'assigned_to_current_driver': assignedToCurrentDriver,
    };
  }

  VehicleInfoEntity toEntity() => this;
}
