
import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart' as chat_ui;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neura_care/providers/user.dart';
import 'package:neura_care/providers/theme.dart';
import 'package:neura_care/services/api.dart';
import 'package:neura_care/themes.dart';
import 'package:uuid/uuid.dart';
class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key,required this.type});
  final String type;
  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> 
    with TickerProviderStateMixin {
  final _chatController = InMemoryChatController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isTyping = false;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
    
    // Add welcome message
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _addWelcomeMessage();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _addWelcomeMessage() {
    _chatController.insertMessage(
      TextMessage(
        id: const Uuid().v4(),
        authorId: 'neuracare_bot',
        createdAt: DateTime.now().toUtc(),
        text: 'Hello! I\'m your NeuraCare health assistant. I can help you with ${widget.type} related questions. How can I assist you today?',
      ),
    );
  }
  
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
    
    // Show typing indicator
    setState(() {
      _isTyping = true;
    });
    
    // Send bot response after a short delay
    _sendBotResponse(messageText);
    
    // Show notification to user
    _showUserNotification('Message sent');
  }
  
  void _sendBotResponse(String userMessage) {
    // Simulate bot thinking time with typing indicator
    Future.delayed(const Duration(milliseconds: 500), () async {
      if (mounted) {
        try {
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
        } catch (e) {
          _chatController.insertMessage(
            TextMessage(
              id: const Uuid().v4(),
              authorId: 'neuracare_bot',
              createdAt: DateTime.now().toUtc(),
              text: 'I apologize, but I\'m having trouble processing your request right now. Please try again in a moment.',
            ),
          );
        } finally {
          if (mounted) {
            setState(() {
              _isTyping = false;
            });
          }
        }
      }
    });
  }

  Future<String> _generateBotResponse(String userMessage) async {

    final message = userMessage.toLowerCase();
    return await getGeminiResponse(message, widget.type, ref.read(userProviderNotifier).token!);
    
    
  }
  
  void _showUserNotification(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.check_circle_outline,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(message),
            ],
          ),
          duration: const Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppTheme.healthGreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }

  String _getChatTitle() {
    switch (widget.type.toLowerCase()) {
      case 'diet':
        return 'Diet Assistant';
      case 'lifestyle':
        return 'Lifestyle Coach';
      case 'mental':
        return 'Mental Health Support';
      case 'medical':
        return 'Medical Assistant';
      default:
        return 'Health Assistant';
    }
  }

  IconData _getChatIcon() {
    switch (widget.type.toLowerCase()) {
      case 'diet':
        return Icons.restaurant_menu;
      case 'exercise':
        return Icons.fitness_center;
      case 'mental':
        return Icons.psychology;
      case 'medical':
        return Icons.medical_services;
      default:
        return Icons.chat;
    }
  }
  @override
  Widget build(BuildContext context) {
    final appUser = ref.watch(userProviderNotifier);
    final currentUserId = appUser.email.isNotEmpty ? appUser.email : 'anonymous';
    final theme = Theme.of(context);
    final isDark = ref.watch(themeProvider) == ThemeMode.dark;
    
    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBackground : AppTheme.lightBackground,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    AppTheme.darkBackground,
                    AppTheme.darkSurface.withOpacity(0.8),
                  ]
                : [
                    AppTheme.lightBackground,
                    AppTheme.primaryColor.withOpacity(0.05),
                  ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              _buildCustomAppBar(theme, isDark),
              
              // Chat Content
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                        child: chat_ui.Chat(
                          currentUserId: currentUserId,
                          resolveUser: (userId) async {
                            return null;
                          },
                          chatController: _chatController,
                          onMessageSend: onMessageTyped,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              
              // Typing Indicator
              if (_isTyping) _buildTypingIndicator(isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomAppBar(ThemeData theme, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getChatIcon(),
              color: AppTheme.primaryColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getChatTitle(),
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Powered by NeuraCare AI',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: (isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface)
                        .withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.healthGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.healthGreen.withOpacity(0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppTheme.healthGreen,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'Online',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.healthGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? AppTheme.darkBackground : AppTheme.lightBackground,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? AppTheme.darkOutline : AppTheme.lightOutline,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'NeuraCare is typing...',
                  style: TextStyle(
                    color: (isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface)
                        .withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}