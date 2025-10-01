import 'package:ai_transport/src/feature/home/domain/entities/cancellation_reason_entity.dart';

class CancellationReason {
  final String code;
  final String nameAr;
  final String nameEn;
  final bool requiresPhoto;
  final bool requiresNotes;

  CancellationReason({
    required this.code,
    required this.nameAr,
    required this.nameEn,
    required this.requiresPhoto,
    required this.requiresNotes,
  });

  factory CancellationReason.fromJson(Map<String, dynamic> json) {
    return CancellationReason(
      code: json['code'],
      nameAr: json['name_ar'],
      nameEn: json['name_en'],
      requiresPhoto: json['requires_photo'],
      requiresNotes: json['requires_notes'],
    );
  }
  CancellationReasonEntity toEntity() {
    return CancellationReasonEntity(
      code: code,
      nameAr: nameAr,
      nameEn: nameEn,
      requiresPhoto: requiresPhoto,
      requiresNotes: requiresNotes,
    );
  }
}
