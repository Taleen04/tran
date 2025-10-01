import 'package:equatable/equatable.dart';
import 'package:ai_transport/src/feature/profile/domain/entity/wallet_entity.dart';

abstract class WalletState extends Equatable {
  const WalletState();
  
  @override
  List<Object?> get props => [];
}

class WalletInitial extends WalletState {
  const WalletInitial();
  
  @override
  List<Object?> get props => [];
}

class WalletLoading extends WalletState {
  const WalletLoading();
  
  @override
  List<Object?> get props => [];
}

class WalletLoaded extends WalletState {
  final WalletEntity wallet;
  final bool isRefreshing;

  const WalletLoaded({
    required this.wallet,
    this.isRefreshing = false,
  });

  @override
  List<Object?> get props => [wallet, isRefreshing];

  WalletLoaded copyWith({
    WalletEntity? wallet,
    bool? isRefreshing,
  }) {
    return WalletLoaded(
      wallet: wallet ?? this.wallet,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }
}

class WalletError extends WalletState {
  final String message;
  final WalletEntity? previousWallet;

  const WalletError({
    required this.message,
    this.previousWallet,
  });

  @override
  List<Object?> get props => [message, previousWallet];
}

