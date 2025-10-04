import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';
import '../widgets/chat_message_bubble.dart';
import '../widgets/chat_input_widget.dart';
import '../widgets/chat_header.dart';

class ChatScreen extends StatefulWidget {
  final int requestId;
  final int conversationId;
  final String clientName;

  const ChatScreen({
    super.key,
    required this.requestId,
    required this.conversationId,
    required this.clientName,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize Pusher and load chat conversation
    context.read<ChatBloc>().add(
      InitializePusherEvent(conversationId: widget.conversationId),
    );
    context.read<ChatBloc>().add(GetChatConversationEvent(widget.requestId));
  }

  @override
  void dispose() {
    // Dispose Pusher when leaving chat screen
    _scrollController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F23),
      body: Column(
        children: [
          // Header
          ChatHeader(
            clientName: widget.clientName,
            onBackPressed: () {
              context.read<ChatBloc>().add(DisposePusherEvent());
              // Always try to pop first, if fails then go to main screen with chat tab
              try {
                context.pop();
              } catch (e) {
                // Go to main screen with chat tab (tab index 1)
                context.go('/main_screen?tab=2');
              }
            },
          ),

          // Messages area
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF1A1A2E),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: BlocConsumer<ChatBloc, ChatState>(
                listener: (context, state) {
                  if (state is ChatConversationLoaded ||
                      state is ChatMessageSent ||
                      state is PusherSend) {
                    _scrollToBottom();
                  }
                },
                builder: (context, state) {
                  var bloc = context.read<ChatBloc>();
                  if (state is ChatLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFFFA726),
                      ),
                    );
                  } else if (state is ChatConversationLoaded ||
                      state is ChatMessageSent ||
                      state is PusherSend) {
                    return ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: bloc.messages.length,
                      itemBuilder: (context, index) {
                        final message = bloc.messages[index];
                        return ChatMessageBubble(message: message);
                      },
                    );
                  } else if (state is ChatError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 64,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'خطأ في تحميل المحادثة',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.message,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              context.read<ChatBloc>().add(
                                GetChatConversationEvent(widget.requestId),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFFA726),
                            ),
                            child: const Text('إعادة المحاولة'),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),

          // Input area
          ChatInputWidget(
            controller: _messageController,
            onSendMessage: _sendTextMessage,
            onSendImage: _sendImageMessage,
            onSendQuickAction: _sendQuickAction,
          ),
        ],
      ),
    );
  }

  void _sendTextMessage(String message) {
    if (message.trim().isNotEmpty) {
      context.read<ChatBloc>().add(
        SendChatMessageEvent(
          requestId: widget.requestId,
          messageType: 'text',
          message: message,
        ),
      );
      _messageController.clear();
    }
  }

  Future<void> _sendImageMessage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      context.read<ChatBloc>().add(
        SendChatMessageEvent(
          requestId: widget.requestId,
          attachments: [File(image.path)],
          messageType: "image",
          message: "image"
        ),
      );
    }
  }

  void _sendQuickAction(String actionType) {
    context.read<ChatBloc>().add(
      SendChatMessageEvent(
        requestId: widget.requestId,
        messageType: 'quick_action',
        quickActionType: actionType,
      ),
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}
