import 'package:flutter/material.dart';

class ChatInputWidget extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onSendMessage;
  final VoidCallback onSendImage;
  final Function(String) onSendQuickAction;

  const ChatInputWidget({
    super.key,
    required this.controller,
    required this.onSendMessage,
    required this.onSendImage,
    required this.onSendQuickAction,
  });

  @override
  State<ChatInputWidget> createState() => _ChatInputWidgetState();
}

class _ChatInputWidgetState extends State<ChatInputWidget> {
  bool _isTyping = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A2E),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Quick action buttons
          // _buildQuickActionButtons(),
          // const SizedBox(height: 12),

          // Input row
          Row(
            children: [
              // Attachment button
              GestureDetector(
                onTap: widget.onSendImage,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFA726).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: const Color(0xFFFFA726).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    Icons.attach_file,
                    color: Color(0xFFFFA726),
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Text input
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2A3E),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: const Color(0xFFFFA726).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: TextField(
                    controller: widget.controller,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    decoration: const InputDecoration(
                      hintText: 'اكتب رسالة...',
                      hintStyle: TextStyle(color: Colors.white54, fontSize: 16),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    maxLines: null,
                    onChanged: (value) {
                      setState(() {
                        _isTyping = value.isNotEmpty;
                      });
                    },
                    onSubmitted: (value) {
                      if (value.trim().isNotEmpty) {
                        widget.onSendMessage(value);
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Send button
              GestureDetector(
                onTap: () {
                  if (widget.controller.text.trim().isNotEmpty) {
                    widget.onSendMessage(widget.controller.text);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color:
                        _isTyping
                            ? const Color(0xFFFFA726)
                            : const Color(0xFFFFA726).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Icon(
                    Icons.send,
                    color: _isTyping ? Colors.white : Colors.white54,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildQuickActionButton(
          icon: Icons.phone,
          label: 'اتصال',
          onTap: () => widget.onSendQuickAction('call'),
        ),
        _buildQuickActionButton(
          icon: Icons.chat,
          label: 'واتساب',
          onTap: () => widget.onSendQuickAction('whatsapp'),
        ),
        _buildQuickActionButton(
          icon: Icons.help,
          label: 'مساعدة',
          onTap: () => widget.onSendQuickAction('help'),
        ),
      ],
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFFFA726).withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFFFFA726).withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: const Color(0xFFFFA726), size: 16),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFFFFA726),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
