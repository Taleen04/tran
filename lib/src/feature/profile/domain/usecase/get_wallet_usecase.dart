
import 'package:ai_transport/src/core/errors/failures.dart';
import 'package:ai_transport/src/feature/profile/domain/entity/wallet_entity.dart';
import 'package:ai_transport/src/feature/profile/domain/repositories/wallet_repository.dart';
import 'package:dartz/dartz.dart';

class GetWalletUseCase {
  final WalletRepository repository;
  
  GetWalletUseCase(this.repository);
  
  Future<Either<Failure, WalletEntity>> call() async {
    return await repository.getWallet();
  }
}