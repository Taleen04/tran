import 'dart:io';
import 'package:ai_transport/src/core/usecases/usecase.dart';
import 'package:ai_transport/src/feature/chat/domain/repository/chat_repository.dart';

class SendChatImageParams {
  final int requestId;
  final File image;
  final String? caption;

  SendChatImageParams({
    required this.requestId,
    required this.image,
    this.caption,
  });
}

class SendChatImageUseCase
    implements UseCase<Map<String, dynamic>, SendChatImageParams> {
  final ChatRepository _repository;

  SendChatImageUseCase(this._repository);

  @override
  Future<Map<String, dynamic>> call(SendChatImageParams params) async {
    return await _repository.sendChatImage(
      requestId: params.requestId,
      image: params.image,
      caption: params.caption,
    );
  }
}
