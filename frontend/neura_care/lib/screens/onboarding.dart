import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
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
    if(!await InternetConnection().hasInternetAccess){
      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No internet connection')),
        );
      }
      return;
    }
    final vitals = Vitals(
      age: int.parse(answers[0]),
      gender: answers[1],
      bpHigh: int.parse(answers[2]),
      bpLow: int.parse(answers[3]),
      heartRate: int.parse(answers[4]),
      sugarLevel: int.parse(answers[5]),
      weight: double.parse(answers[6]),
      cholesterol: int.parse(answers[7]),
      activityLevel: answers[8],
      height: double.parse(answers[9]),
      smoking: answers[10] == 'true' ? true : false,
      drinking: answers[11] == 'true' ? true : false,
      sleepHours: double.parse(answers[12]),
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
       backgroundColor:  Theme.of(context).colorScheme.inversePrimary,
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
