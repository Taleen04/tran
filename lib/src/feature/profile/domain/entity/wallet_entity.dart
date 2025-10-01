import 'package:ai_transport/src/feature/profile/domain/entity/Transaction_entity.dart';
import 'package:equatable/equatable.dart';

class WalletEntity extends Equatable {
  final String id;
  final double companyBalance;
  final String currency;
  final List<TransactionEntity> recentTransactions;
  final String? status;

  const WalletEntity({
    required this.id,
    required this.companyBalance,
    required this.currency,
    required this.recentTransactions,
    this.status,
  });

  // Convenience getter for backward compatibility
  double get balance => companyBalance;
  
  // Convenience getter for backward compatibility
  List<TransactionEntity> get transactions => recentTransactions;

  @override
  List<Object?> get props => [id, companyBalance, currency, recentTransactions, status];
}
