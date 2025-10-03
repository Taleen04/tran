import 'package:flutter/material.dart';
import '../../domain/entities/chat_message_entity.dart';

class ChatMessageBubble extends StatelessWidget {
  final ChatMessageEntity message;

  const ChatMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final bool isFromMe = message.senderType == 'driver';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        mainAxisAlignment:
            isFromMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isFromMe) ...[
            // Avatar for received messages
            CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFFFFA726),
              child: Text(
                message.senderName.isNotEmpty ? message.senderName[0] : '?',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],

          // Message bubble
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color:
                    isFromMe
                        ? const Color(0xFFFFA726)
                        : const Color(0xFF2A2A3E),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(isFromMe ? 20 : 4),
                  bottomRight: Radius.circular(isFromMe ? 4 : 20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Message content
                  if (message.type == 'text' && message.content != null)
                    Text(
                      message.content!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        height: 1.4,
                      ),
                    )
                  else if (message.type == 'image' &&
                      message.file != null)
                    _buildImageMessage()
                  else if (message.type == 'voice' &&
                      message.file != null)
                    _buildVoiceMessage()
                  // else if (message.messageType == 'quick_action' &&
                  //     message.quickActionType != null)
                  //   _buildQuickActionMessage()
                  else
                    const Text(
                      'رسالة غير مدعومة',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),

                  const SizedBox(height: 4),

                  // Timestamp and status
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatTime(DateTime.parse(message.formattedTime)),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                      if (isFromMe) ...[
                        const SizedBox(width: 4),
                        Icon(
                          message.isRead ? Icons.done_all : Icons.done,
                          color:
                              message.isRead
                                  ? Colors.blue
                                  : Colors.white.withOpacity(0.7),
                          size: 16,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),

          if (isFromMe) ...[
            const SizedBox(width: 8),
            // Avatar for sent messages
            CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFF2A2A3E),
              child: const Icon(Icons.person, color: Colors.white, size: 16),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildImageMessage() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 200, maxHeight: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[300],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          message.file!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: 100,
              color: Colors.grey[300],
              child: const Icon(Icons.image, color: Colors.grey, size: 40),
            );
          },
        ),
      ),
    );
  }

  Widget _buildVoiceMessage() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.play_arrow, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          const Text(
            'رسالة صوتية',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }

  // Widget _buildQuickActionMessage() {
  //   String actionText = '';
  //   IconData actionIcon = Icons.help;
  //
  //   switch (message.quickActionType) {
  //     case 'call':
  //       actionText = 'اتصال';
  //       actionIcon = Icons.phone;
  //       break;
  //     case 'whatsapp':
  //       actionText = 'واتساب';
  //       actionIcon = Icons.chat;
  //       break;
  //     case 'help':
  //       actionText = 'مساعدة';
  //       actionIcon = Icons.help;
  //       break;
  //   }
  //
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  //     decoration: BoxDecoration(
  //       color: Colors.white.withOpacity(0.1),
  //       borderRadius: BorderRadius.circular(20),
  //     ),
  //     child: Row(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         Icon(actionIcon, color: Colors.white, size: 20),
  //         const SizedBox(width: 8),
  //         Text(
  //           actionText,
  //           style: const TextStyle(color: Colors.white, fontSize: 14),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}د';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}س';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}د';
    } else {
      return 'الآن';
    }
  }
}
