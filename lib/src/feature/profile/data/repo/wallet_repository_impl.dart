
import 'package:ai_transport/src/core/errors/failures.dart';
import 'package:ai_transport/src/feature/profile/data/data_source/wallet_remote_data_source.dart';
import 'package:ai_transport/src/feature/profile/domain/entity/wallet_entity.dart';
import 'package:ai_transport/src/feature/profile/domain/repositories/wallet_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class WalletRepositoryImpl implements WalletRepository {
  final WalletRemoteDataSource remoteDataSource;
  
  WalletRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, WalletEntity>> getWallet() async {
    try {
      final wallet = await remoteDataSource.getWallet();
      return Right(wallet);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError) {
        return Left(NetworkFailure());
      }
      return Left(ServerFailure(message: e.message ?? 'Server error occurred'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addTransaction({
    required String type,
    required double amount,
    required String description,
  }) async {
    try {
      await remoteDataSource.addTransaction(
        type: type,
        amount: amount,
        description: description,
      );
      return const Right(null);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError) {
        return Left(NetworkFailure());
      }
      return Left(ServerFailure(message: e.message ?? 'Server error occurred'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

}