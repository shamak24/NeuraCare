import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
class MedsTab extends ConsumerWidget{
  const MedsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Center(
      child: Text("Meds Tab"),
    );
  }
}