import 'package:flutter/material.dart';
import 'package:neura_care/screens/chat.dart';

class ChatTypeSelector extends StatelessWidget {
  
  const ChatTypeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Chat Type"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ChatScreen(type: "lifestyle")));
              },
              child: const Text("lifestyle"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ChatScreen(type: "diet")));
              },
              child: const Text("diet"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ChatScreen(type: "medical")));
              },
              child: const Text("medical"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ChatScreen(type: "symptoms")));
              },
              child: const Text("symptoms"),
            ),
          ],
        ),
      ),
    );
  }
}

