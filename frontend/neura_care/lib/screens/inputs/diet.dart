
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:neura_care/providers/diet.dart';
import 'package:neura_care/models/diet.dart';
import 'package:neura_care/providers/user.dart';
import 'package:neura_care/services/api.dart';

class DietInputScreen extends ConsumerStatefulWidget {
  const DietInputScreen({super.key});

  @override
  ConsumerState<DietInputScreen> createState() => _DietInputScreenState();
}

class _DietInputScreenState extends ConsumerState<DietInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final _allergiesController = TextEditingController();
  
  bool _vegan = false;
  bool _vegetarian = false;
  bool _glutenFree = false;
  bool _lactoseFree = false;
  bool _keto = false;
  List<CuisineType> _selectedCuisines = [];
  List<String> _allergies = [];

  @override
  void initState() {
    super.initState();
    // Initialize form with current diet data if available
    final currentDiet = ref.read(dietProvider);
    if (currentDiet != null) {
      _vegan = currentDiet.vegan;
      _vegetarian = currentDiet.vegetarian;
      _glutenFree = currentDiet.glutenFree;
      _lactoseFree = currentDiet.lactoseFree;
      _keto = currentDiet.keto;
      _selectedCuisines = List.from(currentDiet.cuisinePreferences);
      _allergies = List.from(currentDiet.allergies);
      _allergiesController.text = _allergies.join(', ');
    }
  }

  @override
  void dispose() {
    _allergiesController.dispose();
    super.dispose();
  }

  void _updateAllergies(String value) {
    setState(() {
      _allergies = value
          .split(',')
          .map((allergy) => allergy.trim())
          .where((allergy) => allergy.isNotEmpty)
          .toList();
    });
  }

  void _toggleCuisine(CuisineType cuisine) {
    setState(() {
      if (_selectedCuisines.contains(cuisine)) {
        _selectedCuisines.remove(cuisine);
      } else {
        _selectedCuisines.add(cuisine);
      }
    });
  }

  void _submitForm() async{
    if (_formKey.currentState!.validate()) {
      final diet = Diet(
        vegan: _vegan,
        vegetarian: _vegetarian,
        glutenFree: _glutenFree,
        lactoseFree: _lactoseFree,
        keto: _keto,
        cuisinePreferences: _selectedCuisines,
        allergies: _allergies,
      );
      
      if(InternetConnection().hasInternetAccess == false){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No internet connection')),
        );
        return;
      }
      await updateUserDiet(ref.read(userProviderNotifier).token!, diet);
      ref.read(dietProvider.notifier).setDiet(diet);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Diet preferences updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate back
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diet Preferences'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dietary Restrictions Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dietary Restrictions',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 16),
                      CheckboxListTile(
                        title: const Text('Vegan'),
                        subtitle: const Text('No animal products'),
                        value: _vegan,
                        onChanged: (value) {
                          setState(() {
                            _vegan = value ?? false;
                            if (_vegan) _vegetarian = true; // Vegan implies vegetarian
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: const Text('Vegetarian'),
                        subtitle: const Text('No meat or fish'),
                        value: _vegetarian,
                        onChanged: (value) {
                          setState(() {
                            _vegetarian = value ?? false;
                            if (!_vegetarian) _vegan = false; // Can't be vegan without being vegetarian
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: const Text('Gluten Free'),
                        subtitle: const Text('No gluten-containing grains'),
                        value: _glutenFree,
                        onChanged: (value) {
                          setState(() {
                            _glutenFree = value ?? false;
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: const Text('Lactose Free'),
                        subtitle: const Text('No dairy products'),
                        value: _lactoseFree,
                        onChanged: (value) {
                          setState(() {
                            _lactoseFree = value ?? false;
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: const Text('Keto'),
                        subtitle: const Text('Low carb, high fat'),
                        value: _keto,
                        onChanged: (value) {
                          setState(() {
                            _keto = value ?? false;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),

              // Cuisine Preferences Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cuisine Preferences',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 4.0,
                        children: CuisineType.values.map((cuisine) {
                          final isSelected = _selectedCuisines.contains(cuisine);
                          return FilterChip(
                            label: Text(cuisine.name),
                            selected: isSelected,
                            onSelected: (selected) => _toggleCuisine(cuisine),
                            selectedColor: Theme.of(context).colorScheme.primaryContainer,
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Allergies Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Allergies',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _allergiesController,
                        decoration: const InputDecoration(
                          labelText: 'Allergies',
                          hintText: 'e.g., nuts, shellfish, eggs (separate with commas)',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.warning_amber),
                        ),
                        maxLines: 3,
                        onChanged: _updateAllergies,
                      ),
                      if (_allergies.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 4.0,
                          children: _allergies.map((allergy) {
                            return Chip(
                              label: Text(allergy),
                              deleteIcon: const Icon(Icons.close, size: 18),
                              onDeleted: () {
                                setState(() {
                                  _allergies.remove(allergy);
                                  _allergiesController.text = _allergies.join(', ');
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Save Diet Preferences',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}