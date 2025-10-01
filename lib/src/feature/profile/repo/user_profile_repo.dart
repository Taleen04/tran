import 'package:ai_transport/src/feature/profile/data/data_source/profile_data_source.dart';
import 'package:ai_transport/src/feature/profile/domain/entity/profile_entity.dart';

class UserProfileRepo {
  final UserProfileDataSource userProfileDataSource;
  UserProfileRepo(this.userProfileDataSource);

  Future<StaffProfileEntity?> getUserProfile() async {
    final userProfileModel = await userProfileDataSource.userProfile();
    if (userProfileModel == null) return null;
     
    return userProfileModel.toEntity();
  }


  Future<StaffProfileEntity?> updateUserStatus(bool onlineStatus, bool isOnline) async {
    final userProfileModel = await userProfileDataSource.updateUserStatus(onlineStatus, isOnline);
    if (userProfileModel == null) return null;
    return userProfileModel.toEntity();
  }
}
