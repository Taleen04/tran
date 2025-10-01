class CancellationReasonEntity {
  final String code;
  final String nameAr;
  final String nameEn;
  final bool requiresPhoto;
  final bool requiresNotes;

  CancellationReasonEntity({
    required this.code,
    required this.nameAr,
    required this.nameEn,
    required this.requiresPhoto,
    required this.requiresNotes,
  });
}
