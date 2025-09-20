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
        child: Text("Welcome to NeuraCare! ${user.name}\n${user.email}"),
      ),
    );
  }
}
