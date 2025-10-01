
import 'package:ai_transport/src/core/errors/failures.dart';
import 'package:ai_transport/src/feature/profile/domain/entity/wallet_entity.dart';
import 'package:dartz/dartz.dart';

abstract class WalletRepository {
  Future<Either<Failure, WalletEntity>> getWallet();
  Future<Either<Failure, void>> addTransaction({
    required String type,
    required double amount,
    required String description,
  });
}