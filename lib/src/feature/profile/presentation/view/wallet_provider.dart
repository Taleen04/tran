import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_transport/src/feature/profile/data/data_source/wallet_remote_data_source.dart';
import 'package:ai_transport/src/feature/profile/data/repo/wallet_repository_impl.dart';
import 'package:ai_transport/src/feature/profile/domain/usecase/get_wallet_usecase.dart';
import 'package:ai_transport/src/feature/profile/presentation/view_models/bloc/information_wallet_bloc/wallet_bloc.dart';
import 'package:ai_transport/src/feature/profile/presentation/view/wallet_screen.dart';

class WalletProvider extends StatelessWidget {
  const WalletProvider({super.key});

  @override
  Widget build(BuildContext context) {
    final walletRepository = WalletRepositoryImpl(
      remoteDataSource: WalletRemoteDataSourceImpl(),
    );
    
    return BlocProvider(
      create: (context) => WalletBloc(
        getWalletUseCase: GetWalletUseCase(walletRepository),
        walletRepository: walletRepository,
      ),
      child: WalletScreen(walletRepository: walletRepository),
    );
  }
}
