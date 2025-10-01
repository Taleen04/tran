
import 'package:ai_transport/src/core/database/api/apiclient.dart';
import 'package:ai_transport/src/core/resources/api_constants.dart';

class ChangePasswordDataSource {

  ChangePasswordDataSource();

  Future<void> changePassword( String lastPassword,  String newPassword) async {
    try {
  final res=  await ApiClient.dio.post(
        ApiConstants.changePassword,
        data: {
          'current_password': lastPassword,
          'new_password': newPassword,
        },
      );
      if (res.statusCode == 200) {
        return res.data;
      } 
    } catch (e) {
    }
  }
}
