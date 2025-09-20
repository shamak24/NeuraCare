import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neura_care/data/onboarding_questions.dart';
import 'package:neura_care/models/vitals.dart';
import 'package:neura_care/providers/user.dart';
import 'package:neura_care/providers/vitals.dart';
import 'package:neura_care/services/api.dart';
import 'package:neura_care/widgets/onboarding_question.dart';

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

  void submitAnswers(String answer) async{
    setState(() {
      answers[currentQuestionIndex] = answer;
    });
    final vitals = Vitals(
      bloodPressure: double.parse(answers[2]),
      heartRate: int.parse(answers[3]),
      sugarLevel: double.parse(answers[4]),
      weight: double.parse(answers[5]),
      cholesterol: double.parse(answers[6]),
      activityLevel: answers[7],
      gender: answers[1],
      age: int.parse(answers[0]),
      height: double.parse(answers[8]),
    );
    print(vitals);
    try{
        await createUserVitals(ref.read(userProviderNotifier.notifier).state.token!, vitals);
        double score = await getScore(ref.read(userProviderNotifier.notifier).state.token!);
        ref.read(vitalsProviderNotifier.notifier).setVitals(vitals);
        ref.read(userProviderNotifier.notifier).updateHealthScore(score);
    }catch(e){
        if(mounted){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error submitting vitals: $e')),
          );
        }
    }
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
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(16.0),
          elevation: 4.0,

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Here are some question we would be asking you"),
              OnboardingQuestion(
                currentIndex: currentQuestionIndex,
                onAnswered: nextQuestion,
                onPrevious: previousQuestion,
                onSubmit: submitAnswers,
                previousAnswer: answers[currentQuestionIndex],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
