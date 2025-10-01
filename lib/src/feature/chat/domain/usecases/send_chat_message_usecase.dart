import 'dart:io';
import 'package:ai_transport/src/core/usecases/usecase.dart';
import 'package:ai_transport/src/feature/chat/domain/entities/chat_message_entity.dart';
import 'package:ai_transport/src/feature/chat/domain/repository/chat_repository.dart';

class SendChatMessageParams {
  final int requestId;
  final String messageType;
  final String? message;
  final File? attachment;
  final String? quickActionType;

  SendChatMessageParams({
    required this.requestId,
    required this.messageType,
    this.message,
    this.attachment,
    this.quickActionType,
  });
}

class SendChatMessageUseCase
    implements UseCase<ChatMessageEntity, SendChatMessageParams> {
  final ChatRepository _repository;

  SendChatMessageUseCase(this._repository);

  @override
  Future<ChatMessageEntity> call(SendChatMessageParams params) async {
    return await _repository.sendChatMessage(
      requestId: params.requestId,
      messageType: params.messageType,
      message: params.message,
      attachment: params.attachment,
      quickActionType: params.quickActionType,
    );
  }
}
