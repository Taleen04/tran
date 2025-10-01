import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_transport/src/feature/chat/domain/usecases/get_chat_conversation_usecase.dart';
import 'package:ai_transport/src/feature/chat/domain/usecases/send_chat_message_usecase.dart';
import 'package:ai_transport/src/feature/chat/domain/usecases/send_chat_image_usecase.dart';
import 'package:ai_transport/src/feature/chat/domain/usecases/get_all_conversations_usecase.dart';
import 'package:ai_transport/src/feature/chat/presentation/bloc/chat_event.dart';
import 'package:ai_transport/src/feature/chat/presentation/bloc/chat_state.dart';
import 'package:ai_transport/src/feature/chat/data/services/pusher_service.dart';
import 'package:ai_transport/src/feature/chat/domain/entities/chat_message_entity.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetChatConversationUseCase _getChatConversationUseCase;
  final SendChatMessageUseCase _sendChatMessageUseCase;
  final SendChatImageUseCase _sendChatImageUseCase;
  final GetAllConversationsUseCase _getAllConversationsUseCase;
  final PusherService _pusherService = PusherService.instance;
  StreamSubscription<ChatMessageEntity>? _messageSubscription;
  StreamSubscription<Map<String, dynamic>>? _eventSubscription;

  ChatBloc({
    required GetChatConversationUseCase getChatConversationUseCase,
    required SendChatMessageUseCase sendChatMessageUseCase,
    required SendChatImageUseCase sendChatImageUseCase,
    required GetAllConversationsUseCase getAllConversationsUseCase,
  }) : _getChatConversationUseCase = getChatConversationUseCase,
       _sendChatMessageUseCase = sendChatMessageUseCase,
       _sendChatImageUseCase = sendChatImageUseCase,
       _getAllConversationsUseCase = getAllConversationsUseCase,
       super(ChatInitial()) {
    on<GetChatConversationEvent>(_onGetChatConversation);
    on<SendChatMessageEvent>(_onSendChatMessage);
    on<SendChatImageEvent>(_onSendChatImage);
    on<GetAllConversationsEvent>(_onGetAllConversations);
    on<AddNewMessageEvent>(_onAddNewMessage);
    on<MarkMessageAsReadEvent>(_onMarkMessageAsRead);
    on<InitializePusherEvent>(_onInitializePusher);
    on<DisposePusherEvent>(_onDisposePusher);

    _initializePusherListeners();
  }

  Future<void> _onGetChatConversation(
    GetChatConversationEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    try {
      final conversation = await _getChatConversationUseCase(event.requestId);
      emit(ChatConversationLoaded(conversation));
    } catch (e) {
      emit(ChatError('Failed to get chat conversation: $e'));
    }
  }

  Future<void> _onSendChatMessage(
    SendChatMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    try {
      final message = await _sendChatMessageUseCase(
        SendChatMessageParams(
          requestId: event.requestId,
          messageType: event.messageType,
          message: event.message,
          attachment: event.attachment,
          quickActionType: event.quickActionType,
        ),
      );
      emit(ChatMessageSent(message));
    } catch (e) {
      emit(ChatError('Failed to send message: $e'));
    }
  }

  Future<void> _onSendChatImage(
    SendChatImageEvent event,
    Emitter<ChatState> emit,
  ) async {
    try {
      final result = await _sendChatImageUseCase(
        SendChatImageParams(
          requestId: event.requestId,
          image: event.image,
          caption: event.caption,
        ),
      );
      emit(ChatImageSent(result));
    } catch (e) {
      emit(ChatError('Failed to send image: $e'));
    }
  }

  Future<void> _onGetAllConversations(
    GetAllConversationsEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    try {
      final conversations = await _getAllConversationsUseCase(
        GetAllConversationsParams(status: event.status),
      );
      emit(ChatConversationListLoaded(conversations));
    } catch (e) {
      emit(ChatError('Failed to get conversations: $e'));
    }
  }

  void _onAddNewMessage(AddNewMessageEvent event, Emitter<ChatState> emit) {
    // This will be used for real-time message updates via WebSocket
    if (event.message is ChatMessageEntity) {
      emit(ChatMessageAdded(event.message as ChatMessageEntity));
    }
  }

  void _onMarkMessageAsRead(
    MarkMessageAsReadEvent event,
    Emitter<ChatState> emit,
  ) {
    // This will be used to mark messages as read
    // Implementation depends on your specific requirements
  }

  Future<void> _onInitializePusher(
    InitializePusherEvent event,
    Emitter<ChatState> emit,
  ) async {
    try {
      await _pusherService.initialize();
      if (event.conversationId != null) {
        await _pusherService.subscribeToChannel(
          'transport-chat.${event.conversationId}',
        );
      }
      print('🔌 Pusher initialized for conversation: ${event.conversationId}');
    } catch (e) {
      print('❌ Failed to initialize Pusher: $e');
    }
  }

  Future<void> _onDisposePusher(
    DisposePusherEvent event,
    Emitter<ChatState> emit,
  ) async {
    try {
      await _pusherService.disconnect();
      _messageSubscription?.cancel();
      _eventSubscription?.cancel();
      print('🔌 Pusher disposed');
    } catch (e) {
      print('❌ Error disposing Pusher: $e');
    }
  }

  void _initializePusherListeners() {
    // Listen for real-time messages
    _messageSubscription = _pusherService.messageStream.listen(
      (message) {
        add(AddNewMessageEvent(message));
      },
      onError: (error) {
        print('❌ Message stream error: $error');
      },
    );

    // Listen for transport events
    _eventSubscription = _pusherService.eventStream.listen(
      (event) {
        print('📨 Transport event received: ${event['event']}');
        // Handle transport events here if needed
      },
      onError: (error) {
        print('❌ Event stream error: $error');
      },
    );
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    _eventSubscription?.cancel();
    _pusherService.dispose();
    return super.close();
  }
}
