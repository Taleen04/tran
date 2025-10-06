import 'package:ai_transport/src/feature/profile/domain/entity/profile_entity.dart';

class TransportCompanyModel extends TransportCompanyEntity {
  TransportCompanyModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    required super.address,
    required super.licenseNumber,
    super.taxNumber,
    required super.contactPerson,
    required super.contactPhone,
    required super.serviceAreas,
    required super.walletBalance,
    required super.isActive,
  });

  factory TransportCompanyModel.fromJson(Map<String, dynamic> json) {
    return TransportCompanyModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      licenseNumber: json['license_number'] ?? '',
      taxNumber: json['tax_number'],
      contactPerson: json['contact_person'] ?? '',
      contactPhone: json['contact_phone'] ?? '',
      serviceAreas:
          (json['service_areas'] is List)
              ? List<String>.from(
                (json['service_areas'] as List).map((e) => e.toString()),
              )
              : <String>[],
      walletBalance: (json['wallet_balance'] ?? '0').toString(),
      isActive: json['is_active'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'license_number': licenseNumber,
      'tax_number': taxNumber,
      'contact_person': contactPerson,
      'contact_phone': contactPhone,
      'service_areas': serviceAreas,
      'wallet_balance': walletBalance,
      'is_active': isActive,
    };
  }
}

class StaffProfileModel extends StaffProfileEntity {
  StaffProfileModel({
    required super.id,
    required super.name,
    required super.phone,
    required super.isOnline,
    super.email,

    required super.address,
    required super.latitude,
    required super.longitude,
    required super.rating,
    required super.serviceType,
    required super.currentStatus,
    required super.manualLocationStatus,
    super.photo,
    super.identityImage,
    super.nonConvictionCertificate,
    super.licenseImage,
    super.licenseExpiry,
    required super.transportCompany,
  });

  factory StaffProfileModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> root = Map<String, dynamic>.from(json);

    final Map<String, dynamic> data =
        root['data'] is Map
            ? Map<String, dynamic>.from(root['data'] as Map)
            : <String, dynamic>{};

    // Prefer explicit staff object; otherwise, many APIs put fields directly under data
    final Map<String, dynamic> staff =
        root['staff'] is Map
            ? Map<String, dynamic>.from(root['staff'] as Map)
            : (data['staff'] is Map
                ? Map<String, dynamic>.from(data['staff'] as Map)
                : (data.isNotEmpty ? data : <String, dynamic>{}));

    // transport_company may be under staff or directly under data
    final Map<String, dynamic> companyJson =
        staff['transport_company'] is Map
            ? Map<String, dynamic>.from(staff['transport_company'] as Map)
            : (data['transport_company'] is Map
                ? Map<String, dynamic>.from(data['transport_company'] as Map)
                : <String, dynamic>{});

    return StaffProfileModel(
      id: staff['id'] ?? 0,
      name: staff['name'] ?? '',
      phone: staff['phone'] ?? '',
      isOnline: staff['is_online'] ?? false,
      email:
          (staff['email'] as String?)?.isNotEmpty == true
              ? staff['email'] as String?
              : null,
      address: staff['address'] ?? '',
      latitude: (staff['latitude'] ?? '0').toString(),
      longitude: (staff['longitude'] ?? '0').toString(),
      rating: (staff['rating'] ?? '0').toString(),
      // Some APIs may use service_type instead of employee_type
      serviceType:
          (staff['employee_type'] ?? staff['service_type'] ?? '').toString(),
      // Some APIs may use status instead of current_status
      currentStatus:
          (staff['current_status'] ?? staff['status'] ?? '').toString(),
      manualLocationStatus: (staff['manual_location_status'] ?? '').toString(),
      photo:
          (staff['photo'] as String?)?.isNotEmpty == true
              ? staff['photo'] as String?
              : null,
      identityImage:
          (staff['identity_image'] as String?)?.isNotEmpty == true
              ? staff['identity_image'] as String?
              : null,
      nonConvictionCertificate:
          (staff['non_conviction_certificate'] as String?)?.isNotEmpty == true
              ? staff['non_conviction_certificate'] as String?
              : null,
      licenseImage:
          (staff['license_image'] as String?)?.isNotEmpty == true
              ? staff['license_image'] as String?
              : null,
      licenseExpiry:
          (staff['license_expiry'] as String?)?.isNotEmpty == true
              ? staff['license_expiry'] as String?
              : null,
      transportCompany: TransportCompanyModel.fromJson(companyJson),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'rating': rating,
      'employee_type': serviceType,
      'current_status': currentStatus,
      'manual_location_status': manualLocationStatus,
      'photo': photo,
      'identity_image': identityImage,
      'non_conviction_certificate': nonConvictionCertificate,
      'license_image': licenseImage,
      'license_expiry': licenseExpiry,
      'transport_company': (transportCompany as TransportCompanyModel).toJson(),
    };
  }

  StaffProfileEntity toEntity() => this;
}
