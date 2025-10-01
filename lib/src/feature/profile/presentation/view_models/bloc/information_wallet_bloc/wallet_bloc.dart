import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_transport/src/feature/profile/domain/usecase/get_wallet_usecase.dart';
import 'package:ai_transport/src/feature/profile/domain/repositories/wallet_repository.dart';
import 'package:ai_transport/src/feature/profile/presentation/view_models/bloc/information_wallet_bloc/wallet_event.dart';
import 'package:ai_transport/src/feature/profile/presentation/view_models/bloc/information_wallet_bloc/wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final GetWalletUseCase getWalletUseCase;
  final WalletRepository walletRepository;

  WalletBloc({
    required this.getWalletUseCase,
    required this.walletRepository,
  }) : super(const WalletInitial()) {
    on<LoadWallet>(_onLoadWallet);
    on<RefreshWallet>(_onRefreshWallet);
    on<AddTransaction>(_onAddTransaction);
  }

  Future<void> _onLoadWallet(LoadWallet event, Emitter<WalletState> emit) async {
    emit(const WalletLoading());
    
    final result = await getWalletUseCase();
    
    result.fold(
      (failure) => emit(WalletError(message: _mapFailureToMessage(failure))),
      (wallet) => emit(WalletLoaded(wallet: wallet)),
    );
  }

  Future<void> _onRefreshWallet(RefreshWallet event, Emitter<WalletState> emit) async {
    if (state is WalletLoaded) {
      final currentState = state as WalletLoaded;
      emit(currentState.copyWith(isRefreshing: true));
    }
    
    final result = await getWalletUseCase();
    
    result.fold(
      (failure) => emit(WalletError(
        message: _mapFailureToMessage(failure),
        previousWallet: state is WalletLoaded ? (state as WalletLoaded).wallet : null,
      )),
      (wallet) => emit(WalletLoaded(wallet: wallet)),
    );
  }

  Future<void> _onAddTransaction(AddTransaction event, Emitter<WalletState> emit) async {
    if (state is! WalletLoaded) return;
    
    final currentState = state as WalletLoaded;
    
    final result = await walletRepository.addTransaction(
      type: event.type,
      amount: event.amount,
      description: event.description,
    );
    
    result.fold(
      (failure) => emit(WalletError(
        message: _mapFailureToMessage(failure),
        previousWallet: currentState.wallet,
      )),
      (_) {
        // Refresh wallet data after successful transaction
        add(const RefreshWallet());
      },
    );
  }


  String _mapFailureToMessage(dynamic failure) {
    switch (failure.runtimeType.toString()) {
      case 'NetworkFailure':
        return 'Network error. Please check your internet connection.';
      case 'ServerFailure':
        return failure.message ?? 'Server error occurred. Please try again.';
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }
}
