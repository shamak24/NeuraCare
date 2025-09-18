import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neura_care/data/onboarding_questions.dart';
import 'package:neura_care/providers/user.dart';
import 'package:neura_care/providers/vitals.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

 @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  List<dynamic> answers = List.filled(onboardingQuestions.length, null);
  int currentQuestionIndex = 0;
  
  void nextQuestion(String answer) {
    setState(() {
      answers[currentQuestionIndex] = answer;
      currentQuestionIndex++;
    });
  }

  void previousQuestion() {
    setState(() {
      if (currentQuestionIndex > 0) {
        currentQuestionIndex--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Onboarding'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(userProviderNotifier.notifier).clearUser();
              ref.read(vitalsProviderNotifier.notifier).clearVitals();
            },
          ),
        ],
      ),
      body: Center(child:Text("Welcome to NeuraCare! Please complete your onboarding process."),
        
      )
    );
  }
}