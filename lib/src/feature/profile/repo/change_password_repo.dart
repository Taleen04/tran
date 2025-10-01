import 'package:ai_transport/src/feature/profile/data/data_source/change_password_data_source.dart';

class ChangePasswordRepo {
  final ChangePasswordDataSource changePasswordDataSource;

  ChangePasswordRepo({required this.changePasswordDataSource});



Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
   await changePasswordDataSource.changePassword(currentPassword, newPassword);
  }

}