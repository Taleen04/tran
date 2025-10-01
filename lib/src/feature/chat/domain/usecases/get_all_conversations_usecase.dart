import 'package:ai_transport/src/core/usecases/usecase.dart';
import 'package:ai_transport/src/feature/chat/domain/entities/chat_conversation_list_entity.dart';
import 'package:ai_transport/src/feature/chat/domain/repository/chat_repository.dart';

class GetAllConversationsParams {
  final String? status;

  GetAllConversationsParams({this.status});
}

class GetAllConversationsUseCase
    implements UseCase<ChatConversationListEntity, GetAllConversationsParams> {
  final ChatRepository _repository;

  GetAllConversationsUseCase(this._repository);

  @override
  Future<ChatConversationListEntity> call(
    GetAllConversationsParams params,
  ) async {
    return await _repository.getAllConversations(status: params.status);
  }
}
