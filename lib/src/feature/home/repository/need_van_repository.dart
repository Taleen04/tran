import 'package:ai_transport/src/feature/home/data/data_sources/need_van_data_source.dart';
import 'package:ai_transport/src/feature/home/data/models/need_van_request_model.dart';

abstract class NeedVanRepository {
  Future<NeedVanResponseModel> requestNeedVan({
    required int requestId,
    required NeedVanRequestModel needVanRequest,
  });
}

class NeedVanRepositoryImpl implements NeedVanRepository {
  final NeedVanDataSource dataSource;

  NeedVanRepositoryImpl({required this.dataSource});

  @override
  Future<NeedVanResponseModel> requestNeedVan({
    required int requestId,
    required NeedVanRequestModel needVanRequest,
  }) async {
    return await dataSource.requestNeedVan(
      requestId: requestId,
      needVanRequest: needVanRequest,
    );
  }
}
