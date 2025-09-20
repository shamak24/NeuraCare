import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:neura_care/models/prev_history.dart';
import 'package:neura_care/providers/prev_history.dart';
import 'package:neura_care/providers/user.dart';
import 'package:neura_care/screens/chat.dart';
import 'package:neura_care/screens/chat_type_selector.dart';
import 'package:neura_care/screens/inputs/prev_history.dart';
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
          Text("Your health score is: ${user.healthScore.toStringAsFixed(2)}/100", style: TextStyle(fontSize: 20)),
          if(ref.read(prevHistoryProviderNotifier.notifier).state != PreviousHistory.empty()) ...[
            SizedBox(height: 20),
            Text("Last recorded history:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("Diseases: ${ref.read(prevHistoryProviderNotifier.notifier).state.diseases.join(", ")}"),
            Text("Family History: ${ref.read(prevHistoryProviderNotifier.notifier).state.familyHistory.join(", ")}"),
          
          ]
          else ...[
            SizedBox(height: 20),
            Text("No previous history found.", style: TextStyle(fontSize: 18)),
            TextButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => PreviousHistoryScreen()));
            }, child: Text("Add History"))
          
        ],
        TextButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatTypeSelector()));
        }, child: Text("Chat with NeuraCare"))
        ,
          SizedBox(height: 30),
            Text("Stay healthy!", style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
        ],
      ),
    );
  }
}