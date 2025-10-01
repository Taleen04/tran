import 'package:equatable/equatable.dart';

class TransactionEntity extends Equatable {
  final String id;
  final String type; 
  final double amount;
  final String currency;
  final DateTime date;
  final String description;
  final String? status;
  final String? reference;

  const TransactionEntity({
    required this.id,
    required this.type,
    required this.amount,
    required this.currency,
    required this.date,
    required this.description,
    this.status,
    this.reference,
  });

  @override
  List<Object?> get props => [id, type, amount, currency, date, description, status, reference];
}