import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/chat_bloc.dart';
import '../../data/data_source/chat_data_source.dart';
import '../../data/repository/chat_repository_impl.dart';
import '../../domain/usecases/get_chat_conversation_usecase.dart';
import '../../domain/usecases/send_chat_message_usecase.dart';
import '../../domain/usecases/send_chat_image_usecase.dart';
import '../../domain/usecases/get_all_conversations_usecase.dart';

class ChatProvider {
  static Widget provideChatBloc({required Widget child}) {
    return BlocProvider<ChatBloc>(
      create:
          (context) => ChatBloc(
            getChatConversationUseCase: GetChatConversationUseCase(
              ChatRepositoryImpl(ChatDataSourceImpl()),
            ),
            sendChatMessageUseCase: SendChatMessageUseCase(
              ChatRepositoryImpl(ChatDataSourceImpl()),
            ),
            sendChatImageUseCase: SendChatImageUseCase(
              ChatRepositoryImpl(ChatDataSourceImpl()),
            ),
            getAllConversationsUseCase: GetAllConversationsUseCase(
              ChatRepositoryImpl(ChatDataSourceImpl()),
            ),
          ),
      child: child,
    );
  }
}
