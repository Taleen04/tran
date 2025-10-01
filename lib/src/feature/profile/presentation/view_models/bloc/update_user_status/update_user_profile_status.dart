
import 'package:equatable/equatable.dart';

sealed class UpdateUserProfileState extends Equatable {
  const UpdateUserProfileState();
  
  @override
  List<Object> get props => [];
}

final class UpdateUserProfileInitial extends UpdateUserProfileState {}
