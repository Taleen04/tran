
import 'package:equatable/equatable.dart';

abstract class GetUserProfileEvent extends Equatable {
  const GetUserProfileEvent();

  @override
  List<Object?> get props => [];
}

class FetchUserProfile extends GetUserProfileEvent {
  
  const FetchUserProfile();

  @override
  List<Object?> get props => [];
}
