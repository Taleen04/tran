import 'package:ai_transport/src/feature/calender/data/data_sourse/calender_data_sourse.dart';
import 'package:ai_transport/src/feature/calender/data/model/request_task_model.dart';

class CalendarRepository {
  final CalendarDataSource dataSource;

  CalendarRepository(this.dataSource);

  Future<List<RequestModel>> fetchOrders({
    required String status,
    String? type,
  }) async {
    try {
      final res = await dataSource.fetchCalendar(status: status);
      return res;
    } catch (e) {
      throw Exception("فشل في جلب بيانات التقويم: $e");
    }
  }
}
