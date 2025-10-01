
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure();
}

class ServerFailure extends Failure {
  final String message;
  
  const ServerFailure({required this.message});
  
  @override
  List<Object> get props => [message];
}

class NetworkFailure extends Failure {
  @override
  List<Object> get props => [];
}

class CacheFailure extends Failure {
  @override
  List<Object> get props => [];
}
