import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neura_care/models/dailyMeals.dart';
import 'package:neura_care/models/diet.dart';
import 'package:neura_care/providers/daily_meals.dart';
import 'package:neura_care/providers/diet.dart';
import 'package:neura_care/providers/user.dart';
import 'package:neura_care/screens/inputs/diet.dart';
import 'package:neura_care/screens/mealDetail.dart';
import 'package:neura_care/services/api.dart';
import 'package:neura_care/services/hive_storage.dart';

class MealsTab extends ConsumerWidget{
  const MealsTab({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final diet = ref.watch(dietProvider);

  final dailyMeals = ref.watch(dailyMealsProviderNotifier);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Meals Tab"),
    
          if (diet == Diet.empty()) ...[
                Text("No diet data available"),
                Text("Get started by adding your diet"),
                TextButton(onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DietInputScreen()));
                }, child: const Text("Add Diet")),
              ] else
            Text("Refresh to get today's meals"),
            TextButton(onPressed: () async {
              final dailyMeals = await getDailyMealsData(ref.read(userProviderNotifier).token!);
              ref.read(dailyMealsProviderNotifier.notifier).setDailyMeals(dailyMeals);

            }, child: const Text("refresh")),
            const SizedBox(height: 16),
            if (!dailyMeals.isEmpty) ...[
                TextButton(onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => MealDetailScreen(meal: dailyMeals.breakfast)));
                }, child: Text("Breakfast: ${dailyMeals.breakfast.mealName}")),
                TextButton(onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => MealDetailScreen(meal: dailyMeals.lunch)));
                }, child: Text("Lunch: ${dailyMeals.lunch.mealName}")),
                TextButton(onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => MealDetailScreen(meal: dailyMeals.dinner)));
                }, child: Text("Dinner: ${dailyMeals.dinner.mealName}")),
              ]
        ],
      ),
    );
  }
}