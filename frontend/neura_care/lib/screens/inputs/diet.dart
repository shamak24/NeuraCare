import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:neura_care/providers/daily_meals.dart';
import 'package:neura_care/providers/diet.dart';
import 'package:neura_care/models/diet.dart';
import 'package:neura_care/providers/user.dart';
import 'package:neura_care/services/api.dart';

class DietInputScreen extends ConsumerStatefulWidget {
  const DietInputScreen({super.key});

  @override
  ConsumerState<DietInputScreen> createState() => _DietInputScreenState();
}

class _DietInputScreenState extends ConsumerState<DietInputScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _allergiesController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
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
    
    // Initialize animations
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
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    // Initialize form with current diet data if available
    final currentDiet = ref.read(dietProvider);
    if (currentDiet case Diet diet) {
      _vegan = diet.vegan;
      _vegetarian = diet.vegetarian;
      _glutenFree = diet.glutenFree;
      _lactoseFree = diet.lactoseFree;
      _keto = diet.keto;
      _selectedCuisines = List.from(diet.cuisinePreferences);
      _allergies = List.from(diet.allergies);
      _allergiesController.text = _allergies.join(', ');
    }
    
    // Start animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _allergiesController.dispose();
    _animationController.dispose();
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

  void _submitForm() async {
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
      
      if(!await InternetConnection().hasInternetAccess) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('No internet connection'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
        return;
      }
      
      try {
        await updateUserDiet(ref.read(userProviderNotifier).token!, diet);
        ref.read(dietProvider.notifier).setDiet(diet);
        final dailymeals = await getDailyMealsData(ref.read(userProviderNotifier).token!);
        ref.read(dailyMealsProviderNotifier.notifier).setDailyMeals(dailymeals);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: 8),
                  const Text('Diet preferences updated successfully!'),
                ],
              ),
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              behavior: SnackBarBehavior.floating,
            ),
          );

          // Navigate back
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error updating diet preferences: $e'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    }
  }

  Widget _buildDietaryRestrictionCard(
    String title,
    String subtitle,
    bool value,
    Function(bool?) onChanged,
    IconData icon,
    Color iconColor,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: value ? colorScheme.primaryContainer.withOpacity(0.3) : colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: value ? colorScheme.primary : colorScheme.outline.withOpacity(0.3),
          width: value ? 2 : 1,
        ),
      ),
      child: CheckboxListTile(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(left: 38),
          child: Text(
            subtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ),
        value: value,
        onChanged: onChanged,
        controlAffinity: ListTileControlAffinity.trailing,
        activeColor: colorScheme.primary,
        checkColor: colorScheme.onPrimary,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Diet Preferences',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.surface,
              colorScheme.surfaceContainerLowest,
            ],
          ),
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Section
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            colorScheme.primaryContainer.withOpacity(0.7),
                            colorScheme.secondaryContainer.withOpacity(0.5),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.restaurant_menu,
                            size: 48,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Customize Your Diet',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tell us about your dietary preferences and restrictions',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface.withOpacity(0.7),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),

                    // Dietary Restrictions Section
                    Card(
                      elevation: 4,
                      shadowColor: colorScheme.shadow.withOpacity(0.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            colors: [
                              colorScheme.surfaceContainerHighest,
                              colorScheme.surfaceContainer,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: colorScheme.primaryContainer,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.block,
                                      color: colorScheme.primary,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Dietary Restrictions',
                                    style: theme.textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              
                              _buildDietaryRestrictionCard(
                                'Vegan',
                                'No animal products',
                                _vegan,
                                (value) {
                                  setState(() {
                                    _vegan = value ?? false;
                                    if (_vegan) _vegetarian = true; // Vegan implies vegetarian
                                  });
                                },
                                Icons.eco,
                                Colors.green,
                              ),
                              
                              _buildDietaryRestrictionCard(
                                'Vegetarian',
                                'No meat or fish',
                                _vegetarian,
                                (value) {
                                  setState(() {
                                    _vegetarian = value ?? false;
                                    if (!_vegetarian) _vegan = false; // Can't be vegan without being vegetarian
                                  });
                                },
                                Icons.grass,
                                Colors.lightGreen,
                              ),
                              
                              _buildDietaryRestrictionCard(
                                'Gluten Free',
                                'No gluten-containing grains',
                                _glutenFree,
                                (value) {
                                  setState(() {
                                    _glutenFree = value ?? false;
                                  });
                                },
                                Icons.grain,
                                Colors.orange,
                              ),
                              
                              _buildDietaryRestrictionCard(
                                'Lactose Free',
                                'No dairy products',
                                _lactoseFree,
                                (value) {
                                  setState(() {
                                    _lactoseFree = value ?? false;
                                  });
                                },
                                Icons.no_drinks,
                                Colors.blue,
                              ),
                              
                              _buildDietaryRestrictionCard(
                                'Keto',
                                'Low carb, high fat',
                                _keto,
                                (value) {
                                  setState(() {
                                    _keto = value ?? false;
                                  });
                                },
                                Icons.fitness_center,
                                Colors.purple,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),

                    // Cuisine Preferences Section
                    Card(
                      elevation: 4,
                      shadowColor: colorScheme.shadow.withOpacity(0.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            colors: [
                              colorScheme.surfaceContainerHighest,
                              colorScheme.surfaceContainer,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: colorScheme.secondaryContainer,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.public,
                                      color: colorScheme.secondary,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Cuisine Preferences',
                                    style: theme.textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Wrap(
                                spacing: 8.0,
                                runSpacing: 8.0,
                                children: CuisineType.values.map((cuisine) {
                                  final isSelected = _selectedCuisines.contains(cuisine);
                                  return AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    child: FilterChip(
                                      label: Text(
                                        cuisine.name,
                                        style: TextStyle(
                                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                          color: isSelected 
                                              ? colorScheme.onPrimaryContainer 
                                              : colorScheme.onSurface,
                                        ),
                                      ),
                                      selected: isSelected,
                                      onSelected: (selected) => _toggleCuisine(cuisine),
                                      selectedColor: colorScheme.primaryContainer,
                                      backgroundColor: colorScheme.surface,
                                      side: BorderSide(
                                        color: isSelected 
                                            ? colorScheme.primary 
                                            : colorScheme.outline.withOpacity(0.3),
                                      ),
                                      elevation: isSelected ? 2 : 0,
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Allergies Section
                    Card(
                      elevation: 4,
                      shadowColor: colorScheme.shadow.withOpacity(0.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            colors: [
                              colorScheme.surfaceContainerHighest,
                              colorScheme.surfaceContainer,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: colorScheme.errorContainer,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.warning_amber,
                                      color: colorScheme.error,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Allergies & Intolerances',
                                    style: theme.textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _allergiesController,
                                decoration: InputDecoration(
                                  labelText: 'List your allergies',
                                  hintText: 'e.g., nuts, shellfish, eggs (separate with commas)',
                                  prefixIcon: Icon(
                                    Icons.warning_amber,
                                    color: colorScheme.error,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: colorScheme.outline.withOpacity(0.3),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: colorScheme.primary,
                                      width: 2,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: colorScheme.surface,
                                ),
                                maxLines: 3,
                                onChanged: _updateAllergies,
                                textCapitalization: TextCapitalization.words,
                              ),
                              if (_allergies.isNotEmpty) ...[
                                const SizedBox(height: 12),
                                Wrap(
                                  spacing: 6.0,
                                  runSpacing: 6.0,
                                  children: _allergies.map((allergy) {
                                    return Chip(
                                      label: Text(
                                        allergy,
                                        style: TextStyle(
                                          color: colorScheme.onErrorContainer,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      deleteIcon: Icon(
                                        Icons.close,
                                        size: 18,
                                        color: colorScheme.onErrorContainer,
                                      ),
                                      onDeleted: () {
                                        setState(() {
                                          _allergies.remove(allergy);
                                          _allergiesController.text = _allergies.join(', ');
                                        });
                                      },
                                      backgroundColor: colorScheme.errorContainer,
                                      side: BorderSide.none,
                                    );
                                  }).toList(),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                          elevation: 4,
                          shadowColor: colorScheme.primary.withOpacity(0.3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.save,
                              size: 24,
                              color: colorScheme.onPrimary,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Save Diet Preferences',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}