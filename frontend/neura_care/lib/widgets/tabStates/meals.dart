import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neura_care/models/daily_meals.dart';
import 'package:neura_care/models/diet.dart';
import 'package:neura_care/providers/daily_meals.dart';
import 'package:neura_care/providers/diet.dart';
import 'package:neura_care/providers/user.dart';
import 'package:neura_care/providers/theme.dart';
import 'package:neura_care/screens/inputs/diet.dart';
import 'package:neura_care/screens/detail/meal.dart';
import 'package:neura_care/services/api.dart';
import 'package:neura_care/themes.dart';

class _GentleMascot extends StatefulWidget {
  final String asset;
  final double height;

  const _GentleMascot({Key? key, required this.asset, this.height = 160}) : super(key: key);

  @override
  State<_GentleMascot> createState() => _GentleMascotState();
}

class _GentleMascotState extends State<_GentleMascot> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _floatAnim;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
  _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800));
    _floatAnim = Tween<double>(begin: -6.0, end: 6.0).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
    _scaleAnim = Tween<double>(begin: 0.985, end: 1.02).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
    _ctrl.repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) {
        final dy = _floatAnim.value;
        final scale = _scaleAnim.value;
        return Transform.translate(
          offset: Offset(0, dy),
          child: Transform.scale(
            scale: scale,
            child: child,
          ),
        );
      },
      child: Image.asset(widget.asset, height: widget.height, fit: BoxFit.contain),
    );
  }
}

class MealsTab extends ConsumerWidget{
  const MealsTab({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final diet = ref.watch(dietProvider);
    final dailyMeals = ref.watch(dailyMealsProviderNotifier);
    final isDark = ref.watch(themeProvider) == ThemeMode.dark;
    final theme = Theme.of(context);

    return Container(
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
        child: diet == Diet.empty() 
            ? _buildEmptyState(context, ref, theme, isDark)
            : _buildMealsContent(context, ref, theme, isDark, dailyMeals),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref, ThemeData theme, bool isDark) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(32),
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
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.restaurant_menu,
                size: 64,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "No Diet Plan Found",
              style: theme.textTheme.headlineSmall?.copyWith(
                color: isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Get personalized meal recommendations\nbased on your health goals",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: (isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface)
                    .withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const DietInputScreen())
                );
              },
              icon: const Icon(Icons.add),
              label: const Text("Create Diet Plan"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealsContent(BuildContext context, WidgetRef ref, ThemeData theme, bool isDark, DailyMeals dailyMeals) {
    return CustomScrollView(
      slivers: [
        // Header Section
        SliverToBoxAdapter(
          child: _buildHeader(context, ref, theme, isDark),
        ),
        
        // Refresh Section
        SliverToBoxAdapter(
          child: _buildRefreshSection(context, ref, theme, isDark),
        ),
        
        // Meals Grid
        if (!dailyMeals.isEmpty)
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 3.5,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              delegate: SliverChildListDelegate([
                _buildMealCard(context, "Breakfast", dailyMeals.breakfast, Icons.wb_sunny, AppTheme.warningAmber, isDark),
                _buildMealCard(context, "Lunch", dailyMeals.lunch, Icons.restaurant, AppTheme.primaryColor, isDark),
                _buildMealCard(context, "Dinner", dailyMeals.dinner, Icons.dinner_dining, AppTheme.secondaryColor, isDark),
              ]),
            ),
          ),
        
        // Nutrition Overview
        if (!dailyMeals.isEmpty)
          SliverToBoxAdapter(
            child: _buildNutritionOverview(theme, isDark),
          ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref, ThemeData theme, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
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
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Today's Meals",
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Personalized nutrition for your health",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: (isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface)
                            .withOpacity(0.7),
                      ),
                    ),
                    
                  ],
                ),
              ),
            ],
          ),
          Center(child: _GentleMascot(asset: 'images/mascotVege.png', height: 180)),
        ],
      ),
    );
  }

  Widget _buildRefreshSection(BuildContext context, WidgetRef ref, ThemeData theme, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.refresh,
            color: AppTheme.primaryColor,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Get Fresh Recommendations",
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "Updated meal plans based on your preferences",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: (isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface)
                        .withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final dailyMeals = await getDailyMealsData(ref.read(userProviderNotifier).token!);
              ref.read(dailyMealsProviderNotifier.notifier).setDailyMeals(dailyMeals);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("Refresh"),
          ),
        ],
      ),
    );
  }

  Widget _buildMealCard(BuildContext context, String mealType, dynamic meal, IconData icon, Color accentColor, bool isDark) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => MealDetailScreen(meal: meal))
        );
      },
      child: Container(
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
          children: [
            Container(
              width: 80,
              height: double.infinity,
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              child: Icon(
                icon,
                color: accentColor,
                size: 32,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      mealType,
                      style: TextStyle(
                        color: (isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface)
                            .withOpacity(0.7),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      meal.mealName,
                      style: TextStyle(
                        color: isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.arrow_forward_ios,
                color: accentColor,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionOverview(ThemeData theme, bool isDark) {
    return Container(
      margin: const EdgeInsets.all(16),
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
                Icons.analytics,
                color: AppTheme.primaryColor,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                "Daily Nutrition Overview",
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
                child: _buildNutritionStat("Calories", "2,100", "kcal", AppTheme.warningAmber, isDark),
              ),
              Expanded(
                child: _buildNutritionStat("Protein", "85", "g", AppTheme.primaryColor, isDark),
              ),
              Expanded(
                child: _buildNutritionStat("Carbs", "245", "g", AppTheme.healthGreen, isDark),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionStat(String label, String value, String unit, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
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
              color: (isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface)
                  .withOpacity(0.7),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: TextStyle(
                  color: color,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 2),
              Text(
                unit,
                style: TextStyle(
                  color: color.withOpacity(0.7),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}