class Meal {
  String name;
  String description;
  List<String> ingredients;
  String instructions;
  int prepTime;
  int cookTime;
  int servings;

  Meal({
    required this.name,
    required this.description,
    required this.ingredients,
    required this.instructions,
    required this.prepTime,
    required this.cookTime,
    required this.servings,
  });

  factory Meal.empty() {
    return Meal(
      name: '',
      description: '',
      ingredients: [],
      instructions: '',
      prepTime: 0,
      cookTime: 0,
      servings: 0,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'ingredients': ingredients,
      'instructions': instructions,
      'prepTime': prepTime,
      'cookTime': cookTime,
      'servings': servings,
    };
  }
}
