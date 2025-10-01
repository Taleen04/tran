import 'package:ai_transport/src/feature/profile/domain/entity/wallet_entity.dart';
import 'transaction_model.dart';

class WalletApiResponseModel {
  final bool success;
  final WalletDataModel data;

  const WalletApiResponseModel({
    required this.success,
    required this.data,
  });

  factory WalletApiResponseModel.fromJson(Map<String, dynamic> json) {
    return WalletApiResponseModel(
      success: json['success'] ?? false,
      data: WalletDataModel.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data.toJson(),
    };
  }

  WalletEntity toEntity() {
    return WalletEntity(
      id: 'company_wallet',
      companyBalance: data.companyBalance,
      currency: 'USD', // Default currency since API doesn't specify
      recentTransactions: data.recentTransactions.map((t) => t.toEntity()).toList(),
      status: 'active',
    );
  }
}

class WalletDataModel {
  final double companyBalance;
  final List<TransactionModel> recentTransactions;

  const WalletDataModel({
    required this.companyBalance,
    required this.recentTransactions,
  });

  factory WalletDataModel.fromJson(Map<String, dynamic> json) {
    return WalletDataModel(
      companyBalance: double.tryParse(json['company_balance']?.toString() ?? '0') ?? 0.0,
      recentTransactions: (json['recent_transactions'] as List<dynamic>?)
          ?.map((transaction) => TransactionModel.fromJson(transaction as Map<String, dynamic>))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'company_balance': companyBalance.toString(),
      'recent_transactions': recentTransactions.map((transaction) => transaction.toJson()).toList(),
    };
  }
}
