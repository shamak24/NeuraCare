import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neura_care/screens/inputs/diet.dart';
import 'package:neura_care/providers/user.dart';
import 'package:neura_care/providers/vitals.dart';
import 'package:neura_care/providers/daily_meals.dart';
import 'package:neura_care/screens/inputs/prev_history.dart';
import 'package:neura_care/providers/diet.dart';
import 'package:neura_care/providers/prev_history.dart';
import 'package:neura_care/services/notifications.dart';
import 'package:permission_handler/permission_handler.dart';

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
                ref.read(dietProvider.notifier).clearDiet();
                ref.read(prevHistoryProviderNotifier.notifier).clearPrevHistory();
                Navigator.of(context).pop();
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  void _showPermissionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Row(
                children: [
                  Icon(Icons.notifications),
                  SizedBox(width: 8),
                  Text('Notification Permissions'),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Medication reminders require notification permissions and exact alarm permissions to work properly.',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  FutureBuilder<bool>(
                    future: checkNotificationPermissions(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      
                      bool hasPermissions = snapshot.data ?? false;
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: hasPermissions ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: hasPermissions ? Colors.green : Colors.red,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              hasPermissions ? Icons.check_circle : Icons.error,
                              color: hasPermissions ? Colors.green : Colors.red,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                hasPermissions 
                                    ? 'All permissions granted'
                                    : 'Permissions required',
                                style: TextStyle(
                                  color: hasPermissions ? Colors.green : Colors.red,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    bool granted = await requestNotificationPermissions();
                    if (!granted) {
                      // Open app settings if permissions can't be granted
                      await openAppSettings();
                    }
                    setState(() {}); // Refresh the dialog
                  },
                  child: const Text('Grant Permissions'),
                ),
              ],
            );
          },
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

            Card(
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.medical_information),
                title: const Text('Medical Information'),
                subtitle: const Text('Update your medical information'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PreviousHistoryScreen(),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // Permissions Section
            Text(
              'Permissions',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),

            const SizedBox(height: 16),

            // Notification Permissions Card
            Card(
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.notifications),
                title: const Text('Notification Permissions'),
                subtitle: const Text('Manage notification and alarm permissions'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => _showPermissionsDialog(context),
              ),
            ),

            const SizedBox(height: 24),

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
                leading: Icon(Icons.logout, color: theme.colorScheme.error),
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