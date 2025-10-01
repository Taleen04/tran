import 'package:ai_transport/src/feature/profile/domain/entity/wallet_entity.dart';
import 'transaction_model.dart';

class WalletModel {
  final String id;
  final double companyBalance;
  final String currency;
  final List<TransactionModel> recentTransactions;
  final String? status;

  const WalletModel({
    required this.id,
    required this.companyBalance,
    required this.currency,
    required this.recentTransactions,
    this.status,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      id: 'company_wallet', // Default ID since API doesn't provide one
      companyBalance: double.tryParse(json['company_balance']?.toString() ?? '0') ?? 0.0,
      currency: 'USD', // Default currency since API doesn't specify
      recentTransactions: (json['recent_transactions'] as List<dynamic>?)
          ?.map((transaction) => TransactionModel.fromJson(transaction as Map<String, dynamic>))
          .toList() ?? [],
      status: 'active', // Default status
    );
  }

  factory WalletModel.fromApiResponse(Map<String, dynamic> json) {
    return WalletModel(
      id: 'company_wallet',
      companyBalance: double.tryParse(json['company_balance']?.toString() ?? '0') ?? 0.0,
      currency: 'USD',
      recentTransactions: (json['recent_transactions'] as List<dynamic>?)
          ?.map((transaction) => TransactionModel.fromJson(transaction as Map<String, dynamic>))
          .toList() ?? [],
      status: 'active',
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'company_balance': companyBalance.toString(),
      'recent_transactions': recentTransactions.map((transaction) => transaction.toJson()).toList(),
    };
  }

  WalletEntity toEntity() {
    return WalletEntity(
      id: id,
      companyBalance: companyBalance,
      currency: currency,
      recentTransactions: recentTransactions.map((t) => t.toEntity()).toList(),
      status: status,
    );
  }
}