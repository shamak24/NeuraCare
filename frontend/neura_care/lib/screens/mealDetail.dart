import 'package:flutter/material.dart';
import 'package:neura_care/models/meal.dart';

class MealDetailScreen extends StatelessWidget{
  const MealDetailScreen({super.key, required this.meal});
  final Meal meal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meals"),
      ),
      body: Center(
        child: Column(
          children: [
            Text(meal.mealName),
            const SizedBox(height: 16),
            Text("Ingredients:", style: Theme.of(context).textTheme.titleMedium),
            ...meal.ingredients.map((ingredient) => Text(ingredient)).toList(),
            const SizedBox(height: 16),
            Text("Instructions:", style: Theme.of(context).textTheme.titleMedium),
            ...meal.instructions.map((instruction) => Text(instruction)).toList(),
          ],
        ),
      ),
    );
  }
}