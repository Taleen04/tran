import 'package:ai_transport/src/core/usecases/usecase.dart';
import 'package:ai_transport/src/feature/chat/domain/entities/chat_conversation_entity.dart';
import 'package:ai_transport/src/feature/chat/domain/repository/chat_repository.dart';

class GetChatConversationUseCase
    implements UseCase<ChatConversationEntity, int> {
  final ChatRepository _repository;

  GetChatConversationUseCase(this._repository);

  @override
  Future<ChatConversationEntity> call(int requestId) async {
    return await _repository.getChatConversation(requestId);
  }
}
