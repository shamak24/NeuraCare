import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:neura_care/models/prev_history.dart';
import 'package:neura_care/models/diet.dart';
import 'package:neura_care/models/meal.dart';
import 'package:neura_care/providers/prev_history.dart';
import 'package:neura_care/providers/user.dart';
import 'package:neura_care/providers/diet.dart';
import 'package:neura_care/providers/daily_meals.dart';
import 'package:neura_care/providers/theme.dart';
import 'package:neura_care/services/api.dart';
import 'package:neura_care/screens/chat_type_selector.dart';
import 'package:neura_care/screens/inputs/prev_history.dart';
import 'package:neura_care/screens/inputs/diet.dart';
import 'package:neura_care/screens/detail/diseases.dart';
import 'package:neura_care/screens/detail/health_detail.dart';
import 'package:neura_care/screens/mealDetail.dart';
import 'package:neura_care/themes.dart';

class HomeTab extends ConsumerWidget{
  const HomeTab({super.key});

  String _getCurrentMealTime() {
    final hour = DateTime.now().hour;
    if (hour < 11) {
      return 'breakfast';
    } else if (hour < 16) {
      return 'lunch';
    } else {
      return 'dinner';
    }
  }

  String _getMealTimeDisplay(String mealTime) {
    switch (mealTime) {
      case 'breakfast':
        return 'Breakfast';
      case 'lunch':
        return 'Lunch';
      case 'dinner':
        return 'Dinner';
      default:
        return 'Meal';
    }
  }

  IconData _getMealIcon(String mealTime) {
    switch (mealTime) {
      case 'breakfast':
        return Icons.free_breakfast;
      case 'lunch':
        return Icons.lunch_dining;
      case 'dinner':
        return Icons.dinner_dining;
      default:
        return Icons.restaurant;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProviderNotifier);
    final prevHistory = ref.watch(prevHistoryProviderNotifier);
    final diet = ref.watch(dietProvider);
    final dailyMeals = ref.watch(dailyMealsProviderNotifier);
    final isDark = ref.watch(themeProvider) == ThemeMode.dark;
    final currentMealTime = _getCurrentMealTime();
    final theme = Theme.of(context);

    // Load daily meals if not loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(dailyMealsProviderNotifier.notifier).loadDailyMeals();
    });

    Meal getCurrentMeal() {
      switch (currentMealTime) {
        case 'breakfast':
          return dailyMeals.breakfast;
        case 'lunch':
          return dailyMeals.lunch;
        case 'dinner':
          return dailyMeals.dinner;
        default:
          return Meal.empty();
      }
    }

    Meal getMealByType(String mealType) {
      switch (mealType) {
        case 'breakfast':
          return dailyMeals.breakfast;
        case 'lunch':
          return dailyMeals.lunch;
        case 'dinner':
          return dailyMeals.dinner;
        default:
          return Meal.empty();
      }
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            theme.colorScheme.surface,
            theme.colorScheme.surfaceContainerLowest,
          ],
        ),
      ),
      child: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome back, ${user.name}!",
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Hope you're having a great day",
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: (isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface).withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Health Score Section
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HealthDetailScreen(),
                ),
              );
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      Icons.favorite,
                      color: AppTheme.primaryColor,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Health Score",
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${user.healthScore.toStringAsFixed(1)}/100",
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: AppTheme.primaryColor.withOpacity(0.7),
                    size: 18,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Daily Meals Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.restaurant_menu,
                        color: AppTheme.primaryColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      "Today's Meals",
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                if (diet == Diet.empty()) ...[
                  // Diet not set up
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.errorContainer.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.colorScheme.error.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.restaurant,
                          color: theme.colorScheme.error,
                          size: 32,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Diet Not Set Up",
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.error,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Set up your diet plan to see personalized meal recommendations",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onErrorContainer,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const DietInputScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.add),
                          label: const Text("Set Up Diet"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.error,
                            foregroundColor: theme.colorScheme.onError,
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else if (dailyMeals.isEmpty) ...[
                  // Diet is set up but no meals generated yet
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.colorScheme.primary.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.auto_awesome,
                          color: theme.colorScheme.primary,
                          size: 32,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Generate Your Meals",
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Get personalized meal recommendations based on your diet plan",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: () async {
                            try {
                              final user = ref.read(userProviderNotifier);
                              if (user.token != null) {
                                final dailyMeals = await getDailyMealsData(user.token!);
                                ref.read(dailyMealsProviderNotifier.notifier).setDailyMeals(dailyMeals);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text("Meals generated successfully!"),
                                    backgroundColor: theme.colorScheme.primary,
                                  ),
                                );
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Failed to generate meals: ${e.toString()}"),
                                  backgroundColor: theme.colorScheme.error,
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.auto_awesome),
                          label: const Text("Generate Meals"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: theme.colorScheme.onPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  // Diet is set up and meals are available - show meal buttons
                  Text(
                    "It's time for ${_getMealTimeDisplay(currentMealTime).toLowerCase()}!",
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Current meal button (highlighted)
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        final currentMeal = getCurrentMeal();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MealDetailScreen(
                              meal: currentMeal,
                            ),
                          ),
                        );
                      },
                      icon: Icon(_getMealIcon(currentMealTime)),
                      label: Text("View ${_getMealTimeDisplay(currentMealTime)}"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  
                  // Other meal buttons
                  Row(
                    children: ['breakfast', 'lunch', 'dinner']
                        .where((meal) => meal != currentMealTime)
                        .map((meal) => Expanded(
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    final mealData = getMealByType(meal);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MealDetailScreen(
                                          meal: mealData,
                                        ),
                                      ),
                                    );
                                  },
                                  icon: Icon(
                                    _getMealIcon(meal),
                                    size: 18,
                                  ),
                                  label: Text(
                                    _getMealTimeDisplay(meal),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Medical History Section
          if (prevHistory != PreviousHistory.empty()) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.local_hospital,
                          color: AppTheme.primaryColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        "Medical History",
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DiseasesScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.visibility),
                    label: const Text("View Disease History"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.local_hospital_outlined,
                          color: AppTheme.primaryColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        "Medical History",
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "No previous history found.",
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: (isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface).withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PreviousHistoryScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("Add History"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 24),

          // Footer
          Center(
            child: Text(
              "Stay healthy! 💚",
              style: theme.textTheme.bodyLarge?.copyWith(
                fontStyle: FontStyle.italic,
                color: (isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface).withOpacity(0.6),
              ),
            ),
          ),

          const SizedBox(height: 80), // Extra space for floating button
        ],
      ),
        ),
        // Floating Action Button positioned at bottom right
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChatTypeSelector(),
                ),
              );
            },
            icon: Icon(
              Icons.chat_bubble,
              color: theme.colorScheme.onTertiary,
            ),
            label: Text(
              "AI Assistant",
              style: TextStyle(
                color: theme.colorScheme.onTertiary,
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor: theme.colorScheme.tertiary,
            elevation: 6,
          ),
        ),
      ],
    ),
    );
  }
}