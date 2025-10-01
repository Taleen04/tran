import 'package:ai_transport/src/feature/profile/domain/entity/Transaction_entity.dart';

class TransactionModel extends TransactionEntity {
  final int transportCompanyId;
  final int transportStaffId;
  final int referenceId;
  final int createdBy;
  final String createdAt;

  const TransactionModel({
    required super.id,
    required super.type,
    required super.amount,
    required super.currency,
    required super.date,
    required super.description,
    super.status,
    super.reference,
    required this.transportCompanyId,
    required this.transportStaffId,
    required this.referenceId,
    required this.createdBy,
    required this.createdAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'].toString(),
      type: json['type'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      currency: 'USD', // Default currency since API doesn't specify
      date: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      description: json['description'] ?? '',
      status: 'completed', // Default status
      reference: json['reference_id']?.toString(),
      transportCompanyId: json['transport_company_id'] ?? 0,
      transportStaffId: json['transport_staff_id'] ?? 0,
      referenceId: json['reference_id'] ?? 0,
      createdBy: json['created_by'] ?? 0,
      createdAt: json['created_at'] ?? '',
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'amount': amount,
      'currency': currency,
      'date': date.toIso8601String(),
      'description': description,
      'status': status,
      'reference': reference,
      'transport_company_id': transportCompanyId,
      'transport_staff_id': transportStaffId,
      'reference_id': referenceId,
      'created_by': createdBy,
      'created_at': createdAt,
    };
  }

  TransactionEntity toEntity() {
    return TransactionEntity(
      id: id,
      type: type,
      amount: amount,
      currency: currency,
      date: date,
      description: description,
      status: status,
      reference: reference,
    );
  }
}