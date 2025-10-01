
import 'package:ai_transport/src/core/database/api/apiclient.dart';
import 'package:ai_transport/src/core/resources/api_constants.dart';
import 'package:ai_transport/src/feature/profile/data/models/wallet_api_response_model.dart';
import 'package:ai_transport/src/feature/profile/domain/entity/wallet_entity.dart';
import 'package:dio/dio.dart';

abstract class WalletRemoteDataSource {
  Future<WalletEntity> getWallet();
  Future<void> addTransaction({
    required String type,
    required double amount,
    required String description,
  });
}

class WalletRemoteDataSourceImpl implements WalletRemoteDataSource {
  WalletRemoteDataSourceImpl();

  @override
  Future<WalletEntity> getWallet() async {
    try {
      final response = await ApiClient.dio.get(ApiConstants.wallet);
      
      if (response.statusCode == 200) {
        // Parse the complete API response
        final walletApiResponse = WalletApiResponseModel.fromJson(response.data);
        return walletApiResponse.toEntity();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to load wallet data',
        );
      }
    } on DioException catch (e) {
      throw DioException(
        requestOptions: e.requestOptions,
        message: e.message ?? 'Network error occurred',
      );
    }
  }

  @override
  Future<void> addTransaction({
    required String type,
    required double amount,
    required String description,
  }) async {
    // TODO: Implement add transaction API call
    throw UnimplementedError('Add transaction not implemented yet');
  }
}
 