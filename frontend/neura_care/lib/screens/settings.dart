import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neura_care/screens/inputs/diet.dart';
import 'package:neura_care/providers/user.dart';
import 'package:neura_care/providers/vitals.dart';
import 'package:neura_care/providers/daily_meals.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ref.read(vitalsProviderNotifier.notifier).clearVitals();
                ref.read(userProviderNotifier.notifier).clearUser();
                ref.read(dailyMealsProviderNotifier.notifier).clearDailyMeals();
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: theme.colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Settings Title
            Text(
              'Settings',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Diet Preferences Card
            Card(
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.restaurant_menu),
                title: const Text('Diet Preferences'),
                subtitle: const Text('Update your dietary preferences'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DietInputScreen(),
                    ),
                  );
                },
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Account Section
            Text(
              'Account',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Logout Card
            Card(
              elevation: 2,
              child: ListTile(
                leading: Icon(
                  Icons.logout,
                  color: theme.colorScheme.error,
                ),
                title: Text(
                  'Logout',
                  style: TextStyle(
                    color: theme.colorScheme.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: const Text('Sign out of your account'),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: theme.colorScheme.error,
                ),
                onTap: () => _showLogoutDialog(context, ref),
              ),
            ),
            
            const Spacer(),
            
            // App Version Info
            Center(
              child: Text(
                'NeuraCare v1.0.0',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
