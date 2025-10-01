import 'package:ai_transport/src/feature/home/data/data_sources/cancellation_reasons_data_source.dart';
import 'package:ai_transport/src/feature/home/domain/entities/cancellation_reason_entity.dart';

class CancellationReasonsRepo {
  final CancellationReasonsDataSource dataSource;

  CancellationReasonsRepo({required this.dataSource});

  Future<List<CancellationReasonEntity>> getCancellationReasons() async {
    final models = await dataSource.fetchCancellationReasons();
    return models.map((m) => m.toEntity()).toList(); // list
  }
}