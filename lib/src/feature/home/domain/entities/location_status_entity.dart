enum LocationStatusEnum { //! enum 
  inGarage,
  toAirport,
  inAirport,
  toGarage,
}

extension LocationStatusEnumEx on LocationStatusEnum {
  String toApiValue() {
    switch (this) {
      case LocationStatusEnum.inGarage:
        return "in_garage";
      case LocationStatusEnum.toAirport:
        return "to_airport";
      case LocationStatusEnum.inAirport:
        return "in_airport";
      case LocationStatusEnum.toGarage:
        return "to_garage";
    }
  }
}




class LocationStatusEntity {
  final bool success;
  final String message;
  final String? locationStatus;

  LocationStatusEntity({
    required this.success,
    required this.message,
    this.locationStatus,
  });
}
