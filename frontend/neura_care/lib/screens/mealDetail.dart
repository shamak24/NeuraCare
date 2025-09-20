import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neura_care/models/meal.dart';
import 'package:neura_care/providers/theme.dart';
import 'package:neura_care/themes.dart';

class MealDetailScreen extends ConsumerWidget{
  const MealDetailScreen({super.key, required this.meal});
  final Meal meal;

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
              // App Bar
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: (isDark ? AppTheme.darkSurface : AppTheme.lightSurface).withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface,
                      size: 20,
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppTheme.primaryColor.withOpacity(0.8),
                          AppTheme.secondaryColor.withOpacity(0.6),
                        ],
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.restaurant_menu,
                            size: 48,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            meal.mealName,
                            style: theme.textTheme.headlineMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Quick Stats
                      _buildQuickStats(theme, isDark),
                      
                      const SizedBox(height: 24),
                      
                      // Ingredients Section
                      _buildIngredientsSection(theme, isDark),
                      
                      const SizedBox(height: 24),
                      
                      // Instructions Section
                      _buildInstructionsSection(theme, isDark),
                      
                      const SizedBox(height: 24),
                      
                      // Nutrition Facts
                      _buildNutritionFacts(theme, isDark),
                      
                      const SizedBox(height: 24),
                      
                      // Action Buttons
                      _buildActionButtons(context, theme, isDark),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStats(ThemeData theme, bool isDark) {
    return Container(
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildQuickStat("Prep Time", "15 min", Icons.timer, AppTheme.primaryColor, isDark),
          _buildQuickStat("Servings", "2", Icons.people, AppTheme.secondaryColor, isDark),
          _buildQuickStat("Difficulty", "Easy", Icons.star, AppTheme.warningAmber, isDark),
        ],
      ),
    );
  }

  Widget _buildQuickStat(String label, String value, IconData icon, Color color, bool isDark) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: (isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface).withOpacity(0.7),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildIngredientsSection(ThemeData theme, bool isDark) {
    return Container(
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
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.healthGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.shopping_cart,
                  color: AppTheme.healthGreen,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                "Ingredients",
                style: theme.textTheme.titleLarge?.copyWith(
                  color: isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...meal.ingredients.asMap().entries.map((entry) {
            int index = entry.key;
            String ingredient = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppTheme.healthGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        "${index + 1}",
                        style: TextStyle(
                          color: AppTheme.healthGreen,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      ingredient,
                      style: TextStyle(
                        color: isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildInstructionsSection(ThemeData theme, bool isDark) {
    return Container(
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
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.list_alt,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                "Instructions",
                style: theme.textTheme.titleLarge?.copyWith(
                  color: isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...meal.instructions.asMap().entries.map((entry) {
            int index = entry.key;
            String instruction = entry.value;
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Text(
                        "${index + 1}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      instruction,
                      style: TextStyle(
                        color: isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface,
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildNutritionFacts(ThemeData theme, bool isDark) {
    return Container(
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
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.warningAmber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.analytics,
                  color: AppTheme.warningAmber,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                "Nutrition Facts",
                style: theme.textTheme.titleLarge?.copyWith(
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
                child: _buildNutritionItem("Calories", "420", "kcal", AppTheme.warningAmber, isDark),
              ),
              Expanded(
                child: _buildNutritionItem("Protein", "25g", "per serving", AppTheme.primaryColor, isDark),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildNutritionItem("Carbs", "45g", "complex", AppTheme.healthGreen, isDark),
              ),
              Expanded(
                child: _buildNutritionItem("Fat", "12g", "healthy", AppTheme.secondaryColor, isDark),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionItem(String label, String value, String subtitle, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: (isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface).withOpacity(0.7),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              color: color.withOpacity(0.7),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, ThemeData theme, bool isDark) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Add to favorites functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("${meal.mealName} added to favorites!"),
                      backgroundColor: AppTheme.healthGreen,
                    ),
                  );
                },
                icon: const Icon(Icons.favorite_border),
                label: const Text("Add to Favorites"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  // Share functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Sharing recipe..."),
                      backgroundColor: AppTheme.infoBlue,
                    ),
                  );
                },
                icon: const Icon(Icons.share),
                label: const Text("Share Recipe"),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primaryColor,
                  side: BorderSide(color: AppTheme.primaryColor),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              // Start cooking mode
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Starting cooking mode..."),
                  backgroundColor: AppTheme.healthGreen,
                ),
              );
            },
            icon: const Icon(Icons.play_arrow),
            label: const Text("Start Cooking"),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.healthGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}