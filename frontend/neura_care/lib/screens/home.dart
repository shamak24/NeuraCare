import 'package:flutter/material.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:neura_care/providers/user.dart';
import 'package:neura_care/providers/vitals.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProviderNotifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text("NeuraCare"),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(userProviderNotifier.notifier).clearUser();
              ref.read(vitalsProviderNotifier.notifier).clearVitals();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Text("Welcome, ${user.name}!", style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            Text("Your health score is: ${user.healthScore.toStringAsFixed(2)}", style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
