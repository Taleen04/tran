class VehicleEntity {
  final int id;
  final String type;
  final String plateNumber;
  final String name;
  final String color;
  final String make;
  final String model;
  final int year;
  final int capacityPassengers;
  final int capacityBags;
  final bool wasExisting;

  VehicleEntity({
    required this.id,
    required this.type,
    required this.plateNumber,
    required this.name,
    required this.color,
    required this.make,
    required this.model,
    required this.year,
    required this.capacityPassengers,
    required this.capacityBags,
    required this.wasExisting,
  });
}
