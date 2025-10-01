import 'dart:io';

import 'package:ai_transport/src/feature/profile/data/data_source/edit_profile_data_source.dart';
import 'package:ai_transport/src/feature/profile/domain/entity/profile_entity.dart';

class EditProfileRepository {
  final EditProfileDataSource dataSource;

  EditProfileRepository(this.dataSource);

  Future<bool> updateProfile(StaffProfileEntity updatedUser) async {
    final Map<String, dynamic> body = {
      "full_name": updatedUser.name,
      "phone": updatedUser.phone,
      "email": updatedUser.email,
      "address": updatedUser.address,
    };

    return await dataSource.updateProfile(body);
} 
    Future<Map<String, dynamic>> uploadProfilePhoto(File imageFile) {
    return dataSource.uploadImagePhoto(imageFile);
  }
    /// رفع صورة الهوية
  Future<Map<String, dynamic>> uploadIdCard(File imageFile) {
    return EditProfileDataSource.uploadIdCardImage(imageFile);
  }

  /// رفع صورة عدم المحكومية
  Future<Map<String, dynamic>> uploadUngoverned(File imageFile) {
    return EditProfileDataSource.uploadUngovernedImage(imageFile);
  }

  /// رفع صورة الرخصة
  Future<Map<String, dynamic>> uploadCarLicense(File imageFile) {
    return EditProfileDataSource.carLicens(imageFile);
  }
}

