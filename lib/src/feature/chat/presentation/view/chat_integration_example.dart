import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_state.dart';
import '../providers/chat_provider.dart';
import 'chat_screen.dart';
import 'chat_list_screen.dart';

/// Example of how to integrate chat functionality into your app
class ChatIntegrationExample extends StatelessWidget {
  const ChatIntegrationExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ChatProvider.provideChatBloc(child: const ChatListScreen());
  }
}

/// Example of how to navigate to a specific chat
class ChatNavigationExample extends StatelessWidget {
  final int requestId;
  final String clientName;
  final int conversationId;

  const ChatNavigationExample({
    super.key,
    required this.requestId,
    required this.conversationId,
    required this.clientName,
  });

  @override
  Widget build(BuildContext context) {
    return ChatProvider.provideChatBloc(
      child: ChatScreen(requestId: requestId, clientName: clientName,conversationId: conversationId,),
    );
  }
}

/// Example of how to add a chat button to your existing screens
class ChatButton extends StatelessWidget {
  final int requestId;
  final String clientName;
  final int conversationId;

  const ChatButton({
    super.key,
    required this.requestId,
    required this.clientName,
    required this.conversationId,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder:
                (context) => ChatNavigationExample(
                  requestId: requestId,
                  conversationId: conversationId,
                  clientName: clientName,
                ),
          ),
        );
      },
      backgroundColor: const Color(0xFFFFA726),
      child: const Icon(Icons.chat, color: Colors.white),
    );
  }
}

/// Example of how to show unread message count
class UnreadMessageCount extends StatelessWidget {
  const UnreadMessageCount({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        if (state is ChatConversationListLoaded) {
          final totalUnread = state.conversations.conversations.fold<int>(
            0,
            (sum, conv) => sum + conv.unreadCount,
          );

          if (totalUnread > 0) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                totalUnread.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }
        }
        return const SizedBox.shrink();
      },
    );
  }
}
