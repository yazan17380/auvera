import 'package:flutter/material.dart';
import '../theme/app_theme.dart';



class OrderChatScreen extends StatefulWidget {
  final int orderId;
  const OrderChatScreen({super.key, required this.orderId});

  @override
  State<OrderChatScreen> createState() => _OrderChatScreenState();
}

class _OrderChatScreenState extends State<OrderChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Mock messages - currentUserId = 1 (logged-in user)
  static const int _currentUserId = 1;
  final List<Map<String, dynamic>> _messages = [
    {'senderId': 99, 'senderName': 'Delivery', 'message': 'I have received your order and I am on my way.', 'time': '10:05 AM'},
    {'senderId': 1,  'senderName': 'You',       'message': 'Great! How long will it take?',                   'time': '10:07 AM'},
    {'senderId': 99, 'senderName': 'Delivery',  'message': 'About 20 minutes, traffic is light today.',        'time': '10:08 AM'},
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({
        'senderId': _currentUserId,
        'senderName': 'You',
        'message': text,
        'time': 'Now',
      });
    });

    _messageController.clear();

    // Backend integration note:
    // POST /orders/{orderId}/messages/send { message: text }
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              child: Row(children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                  color: AppColors.textPrimary,
                ),
                Text('Order #${widget.orderId} - Chat',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 17)),
              ]),
            ),
            const Divider(color: AppColors.border),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  final isMe = msg['senderId'] == _currentUserId;
                  return Align(
                    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.72),
                      decoration: BoxDecoration(
                        color: isMe ? AppColors.primary : AppColors.cardWhite,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(16),
                          topRight: const Radius.circular(16),
                          bottomLeft: Radius.circular(isMe ? 16 : 4),
                          bottomRight: Radius.circular(isMe ? 4 : 16),
                        ),
                      ),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(msg['message'],
                            style: TextStyle(fontSize: 13,
                                color: isMe ? Colors.white : AppColors.textPrimary)),
                        const SizedBox(height: 4),
                        Text(msg['time'], style: TextStyle(fontSize: 10,
                            color: isMe ? Colors.white60 : AppColors.textHint)),
                      ]),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              decoration: BoxDecoration(
                color: AppColors.cardWhite,
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: Row(children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      filled: true,
                      fillColor: AppColors.background,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    width: 44, height: 44,
                    decoration: const BoxDecoration(
                        color: AppColors.primary, shape: BoxShape.circle),
                    child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
