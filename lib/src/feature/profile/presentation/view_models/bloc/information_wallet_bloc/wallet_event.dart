import 'package:equatable/equatable.dart';

abstract class WalletEvent extends Equatable {
  const WalletEvent();
  
  @override
  List<Object?> get props => [];
}

class LoadWallet extends WalletEvent {
  const LoadWallet();
  
  @override
  List<Object?> get props => [];
}

class RefreshWallet extends WalletEvent {
  const RefreshWallet();
  
  @override
  List<Object?> get props => [];
}

class AddTransaction extends WalletEvent {
  final String type;
  final double amount;
  final String description;

  const AddTransaction({
    required this.type,
    required this.amount,
    required this.description,
  });

  @override
  List<Object?> get props => [type, amount, description];
}

