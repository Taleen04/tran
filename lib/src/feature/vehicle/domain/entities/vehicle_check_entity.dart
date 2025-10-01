class VehicleCheckEntity {
  final bool exists;
  final VehicleInfoEntity? vehicle;

  VehicleCheckEntity({
    required this.exists,
    this.vehicle,
  });
}

class VehicleInfoEntity {
  final String type;
  final String name;
  final String color;
  final String make;
  final String model;
  final int year;
  final bool isAssigned;
  final bool assignedToCurrentDriver;

  VehicleInfoEntity({
    required this.type,
    required this.name,
    required this.color,
    required this.make,
    required this.model,
    required this.year,
    required this.isAssigned,
    required this.assignedToCurrentDriver,
  });
}
