import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:neura_care/providers/user.dart';
class HomeTab extends ConsumerWidget{
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProviderNotifier);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Welcome, ${user.name}!", style: TextStyle(fontSize: 24)),
          SizedBox(height: 20),
          Text("Your health score is: ${user.healthScore.toStringAsFixed(2)}", style: TextStyle(fontSize: 20)),
        ],
      ),
    );
  }
}