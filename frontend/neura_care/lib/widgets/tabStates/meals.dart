import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neura_care/models/diet.dart';
import 'package:neura_care/providers/diet.dart';
import 'package:neura_care/screens/inputs/diet.dart';

class MealsTab extends ConsumerWidget{
  const MealsTab({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final diet = ref.watch(dietProvider);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Meals Tab"),
          if (diet == Diet.empty()) ...[
                Text("No diet data available"),
                Text("Get started by adding your diet"),
                TextButton(onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DietInputScreen()));
                }, child: const Text("Add Diet")),
              ] else
            Text("Diet data available"),
        ],
      ),
    );
  }
}