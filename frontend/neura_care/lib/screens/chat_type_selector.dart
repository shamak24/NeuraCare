import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neura_care/screens/chat.dart';
import 'package:neura_care/providers/theme.dart';
import 'package:neura_care/themes.dart';

class ChatTypeSelector extends ConsumerWidget {
  const ChatTypeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeProvider) == ThemeMode.dark;
    final theme = Theme.of(context);

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
          child: CustomScrollView(
            slivers: [
              // Header
              SliverToBoxAdapter(
                child: _buildHeader(context, theme, isDark),
              ),
              
              // Chat Type Grid
              SliverPadding(
                padding: const EdgeInsets.all(24),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.85,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  delegate: SliverChildListDelegate([
                    _buildChatTypeCard(
                      context,
                      "Nutrition",
                      "diet",
                      "Get personalized nutrition advice and meal planning",
                      Icons.restaurant_menu,
                      AppTheme.healthGreen,
                      isDark,
                    ),
                    _buildChatTypeCard(
                      context,
                      "Fitness",
                      "lifestyle",
                      "Workout plans and fitness guidance tailored for you",
                      Icons.fitness_center,
                      AppTheme.primaryColor,
                      isDark,
                    ),
                    _buildChatTypeCard(
                      context,
                      "Medical",
                      "medical",
                      "Health consultations and medical information",
                      Icons.medical_services,
                      AppTheme.errorRed,
                      isDark,
                    ),
                    _buildChatTypeCard(
                      context,
                      "Symptoms",
                      "symptoms",
                      "Symptom analysis and health monitoring",
                      Icons.healing,
                      AppTheme.warningAmber,
                      isDark,
                    ),
                  ]),
                ),
              ),
              
              // Quick Access Section
              SliverToBoxAdapter(
                child: _buildQuickAccessSection(context, theme, isDark),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // App Bar
          Row(
            children: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface,
                    size: 20,
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.psychology,
                      color: AppTheme.primaryColor,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "AI Powered",
                      style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Main Header
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.primaryColor,
                        AppTheme.secondaryColor,
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.chat_bubble_outline,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Choose Your Health Assistant",
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  "Select the type of health support you need today",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: (isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface)
                        .withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatTypeCard(
    BuildContext context,
    String title,
    String type,
    String description,
    IconData icon,
    Color color,
    bool isDark,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ChatScreen(type: type),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background gradient
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      color.withOpacity(0.05),
                      color.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            
            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      color: color,
                      size: 28,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Title
                  Text(
                    title,
                    style: TextStyle(
                      color: isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Description
                  Expanded(
                    child: Text(
                      description,
                      style: TextStyle(
                        color: (isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface)
                            .withOpacity(0.7),
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Arrow button
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: color.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Start Chat",
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward,
                          color: color,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAccessSection(BuildContext context, ThemeData theme, bool isDark) {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.speed,
                color: AppTheme.primaryColor,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                "Quick Access",
                style: theme.textTheme.titleMedium?.copyWith(
                  color: isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildQuickAccessButton(
                  context,
                  "Emergency",
                  Icons.emergency,
                  AppTheme.errorRed,
                  () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ChatScreen(type: "emergency"),
                      ),
                    );
                  },
                  isDark,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickAccessButton(
                  context,
                  "General",
                  Icons.chat,
                  AppTheme.infoBlue,
                  () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ChatScreen(type: "general"),
                      ),
                    );
                  },
                  isDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
    bool isDark,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.3),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

