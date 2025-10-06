class TransportCompanyEntity {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String licenseNumber;
  final String? taxNumber;
  final String contactPerson;
  final String contactPhone;
  final List<String> serviceAreas;
  final String walletBalance;
  final bool isActive;

  TransportCompanyEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.licenseNumber,
    this.taxNumber,
    required this.contactPerson,
    required this.contactPhone,
    required this.serviceAreas,
    required this.walletBalance,
    required this.isActive,
  });
}

class StaffProfileEntity {
  final int id;
  final String name;
  final String phone;
  final String? email;
  final String address;
  final String latitude;
  final String longitude;
  final String rating;
  final String serviceType;
  final bool isOnline;
  final String currentStatus;
  final String manualLocationStatus;

  // الصورة الشخصية
  final String? photo;

  // الوثائق
  final String? identityImage;
  final String? nonConvictionCertificate;
  final String? licenseImage;
  final String? licenseExpiry;

  // الشركة
  final TransportCompanyEntity transportCompany;

  StaffProfileEntity({
    required this.id,
    required this.name,
    required this.phone,
    required this.isOnline,
    this.email,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.rating,
    required this.serviceType,
    required this.currentStatus,
    required this.manualLocationStatus,
    this.photo,
    this.identityImage,
    this.nonConvictionCertificate,
    this.licenseImage,
    this.licenseExpiry,
    required this.transportCompany,
  });

  StaffProfileEntity copyWith({
    int? id,
    String? name,
    String? phone,
    String? email,
    String? address,
    String? latitude,
    String? longitude,
    String? rating,
    String? serviceType,
    String? currentStatus,
    String? manualLocationStatus,
    String? photo,
    String? identityImage,
    String? nonConvictionCertificate,
    String? licenseImage,
    String? licenseExpiry,
    bool? isOnline,
    TransportCompanyEntity? transportCompany,
  }) {
    return StaffProfileEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      isOnline: isOnline ?? this.isOnline,
      email: email ?? this.email,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      rating: rating ?? this.rating,
      serviceType: serviceType ?? this.serviceType,
      currentStatus: currentStatus ?? this.currentStatus,
      manualLocationStatus: manualLocationStatus ?? this.manualLocationStatus,
      photo: photo ?? this.photo,
      identityImage: identityImage ?? this.identityImage,
      nonConvictionCertificate:
          nonConvictionCertificate ?? this.nonConvictionCertificate,
      licenseImage: licenseImage ?? this.licenseImage,
      licenseExpiry: licenseExpiry ?? this.licenseExpiry,
      transportCompany: transportCompany ?? this.transportCompany,
    );
  }
}
