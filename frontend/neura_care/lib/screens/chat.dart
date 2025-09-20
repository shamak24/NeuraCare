
import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neura_care/providers/user.dart';
import 'package:neura_care/services/api.dart';
import 'package:uuid/uuid.dart';
class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key,required this.type});
  final String type;
  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _chatController = InMemoryChatController();
  
  void onMessageTyped(String messageText) {
    // This receives the text typed by the user in the chat input.
    final appUser = ref.read(userProviderNotifier);
    final currentUserId = appUser.email.isNotEmpty ? appUser.email : 'anonymous';
    
    debugPrint('Typed message: $messageText');
    
    // Add user message to chat
    _chatController.insertMessage(
      TextMessage(
        id: const Uuid().v4(),
        authorId: currentUserId,
        createdAt: DateTime.now().toUtc(),
        text: messageText,
      ),
    );
    
    // Send bot response after a short delay
    _sendBotResponse(messageText);
    
    // Show notification to user
    _showUserNotification('Message sent: $messageText');
  }
  
  void _sendBotResponse(String userMessage) {
    // Simulate bot thinking time
    Future.delayed(const Duration(seconds: 1), () async {
      if (mounted) {
        final botResponse = await _generateBotResponse(userMessage);
        
        _chatController.insertMessage(
          TextMessage(
            id: const Uuid().v4(),
            authorId: 'neuracare_bot',
            createdAt: DateTime.now().toUtc(),
            text: botResponse,
          ),
        );
        
        _showUserNotification('NeuraCare Bot replied');
      }
    });
  }

  Future<String> _generateBotResponse(String userMessage) async {

    final message = userMessage.toLowerCase();
    return await getGeminiResponse(message, widget.type);
    
    
  }
  
  void _showUserNotification(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    final appUser = ref.watch(userProviderNotifier);
    final currentUserId = appUser.email.isNotEmpty ? appUser.email : 'anonymous';
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat with NeuraCare"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Chat(
        currentUserId: currentUserId,
        resolveUser: (userId) async {
          // Simple resolver: return null (no extra user mapping).
          // The chat will work without detailed user resolution.
          return null;
        },
        chatController: _chatController,
        onMessageSend: onMessageTyped,
        
      ),
    );
  }
}