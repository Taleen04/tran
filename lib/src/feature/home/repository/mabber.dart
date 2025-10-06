import 'dart:developer';
import 'package:ai_transport/src/feature/home/data/models/requset_model.dart';
import 'package:ai_transport/src/feature/home/data/models/vehicle_model.dart';
import 'package:ai_transport/src/feature/home/domain/entities/order_entity.dart';
import 'package:ai_transport/src/feature/home/domain/entities/vehicle_entity.dart';

class RequestMapper {
  static ClientEntity mapClient(ClientModel model) {
    return ClientEntity(name: model.name, phone: model.phone);
  }

  static RequestEntity mapRequest(MyRequestModel model) {
    return RequestEntity(
      id: model.id,
      previousDriverName: model.previousDriverName,
      currentStatus: model.currentStatus,
      currentStatusTypes: model.currentStatusTypes,
      status: model.status,
      client: mapClient(model.client),
      origin: model.origin,
      destination: model.destination,
      vehicleType: model.vehicleType,
      passengers: model.passengers,
      bags: model.bags,
      notes: model.notes,
      minutesRemaining: model.minutesRemaining,
      priorityLevel: model.priorityLevel,
      acceptanceDeadline: model.acceptanceDeadline,
      needsVan: model.needsVan,
      needsAdditionalDriver: model.needsAdditionalDriver,
      createdAt: model.createdAt,
      isUrgent: model.isUrgent,
      isTimedOut: model.isTimedOut,
      acceptanceTimedOut: model.acceptanceTimedOut,
      rejectionCount: model.rejectionCount,
      canAccept: model.canAccept,
      estimatedDistance: model.estimatedDistance,
      estimatedDuration: model.estimatedDuration,
      timeRemaining: model.timeRemaining,
      driverIds: model.driverIds
    );
  }

  static List<RequestEntity> mapList(List<MyRequestModel> models) {
    log(
      '[RequestMapper.mapList] Mapping List<MyRequestModel> of length ${models.length}',
    );
    return models.map(mapRequest).toList();
  }

  // Defensive mapper in case the repository receives a dynamic list (e.g., List<dynamic> or raw JSON list)
  static List<RequestEntity> mapDynamicList(List<dynamic> items) {
    log(
      '[RequestMapper.mapDynamicList] Mapping dynamic list of length ${items.length}',
    );
    final List<RequestEntity> entities = <RequestEntity>[];
    for (final dynamic item in items) {
      try {
        if (item is MyRequestModel) {
          entities.add(mapRequest(item));
        } else if (item is Map<String, dynamic>) {
          final MyRequestModel model = MyRequestModel.fromJson(item);
          entities.add(mapRequest(model));
        } else if (item is Map) {
          // Fallback for Map<dynamic, dynamic>
          final MyRequestModel model = MyRequestModel.fromJson(
            Map<String, dynamic>.from(item),
          );
          entities.add(mapRequest(model));
        } else {
          log(
            '[RequestMapper.mapDynamicList] Skipping unsupported item type: ${item.runtimeType}',
          );
        }
      } catch (e, st) {
        log(
          '[RequestMapper.mapDynamicList] Error mapping item of type ${item.runtimeType}: $e',
          stackTrace: st,
        );
      }
    }
    log(
      '[RequestMapper.mapDynamicList] Mapped entities count: ${entities.length}',
    );
    return entities;
  }

  static VehicleEntity mapVehicle(VehicleModel model) {
    return VehicleEntity(
      id: model.id,
      type: model.type,
      plateNumber: model.plateNumber,
      name: model.name,
      color: model.color,
      make: model.make,
      model: model.model,
      year: model.year,
      capacityPassengers: model.capacityPassengers,
      capacityBags: model.capacityBags,
      wasExisting: model.wasExisting,
    );
  }

  static List<VehicleEntity> mapVehicleList(List<VehicleModel> models) {
    log(
      '[RequestMapper.mapVehicleList] Mapping List<VehicleModel> of length ${models.length}',
    );
    return models.map(mapVehicle).toList();
  }
}
