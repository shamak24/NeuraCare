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
        final score = await getScore(ref.read(userProviderNotifier.notifier).state.token!);
        
       
        ref.read(vitalsProviderNotifier.notifier).setVitals(vitals);
        ref.read(userProviderNotifier.notifier).updateHealthInfo(score);
    }catch(e){
      print('Error submitting vitals: $e');
        if(mounted){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error submitting vitals: $e')),
          );
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final progress = (currentQuestionIndex + 1) / onboardingQuestions.length;
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.primary.withOpacity(0.05),
              colorScheme.secondary.withOpacity(0.02),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              _buildAppBar(theme, progress),
              
              // Main Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Progress Section
                      _buildProgressSection(theme, progress),
                      
                      const SizedBox(height: 32),
                      
                      // Question Card
                      _buildQuestionCard(theme),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(ThemeData theme, double progress) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.95),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Back Button (only show if not first question)
          if (currentQuestionIndex > 0)
            IconButton(
              onPressed: previousQuestion,
              icon: const Icon(Icons.arrow_back),
              tooltip: 'Previous question',
            )
          else
            const SizedBox(width: 48),
          
          // Title
          Expanded(
            child: Text(
              'Health Assessment',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          // Logout Button
          IconButton(
            onPressed: () => _showLogoutDialog(context),
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection(ThemeData theme, double progress) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Question ${currentQuestionIndex + 1} of ${onboardingQuestions.length}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${(progress * 100).round()}%',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Progress Bar
            Container(
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: theme.colorScheme.surfaceVariant,
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: progress,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.primary,
                        theme.colorScheme.secondary,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            Text(
              'Please answer the following questions to help us provide personalized health recommendations.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCard(ThemeData theme) {
    return Card(
      elevation: 8,
      shadowColor: theme.colorScheme.shadow.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: OnboardingQuestion(
          currentIndex: currentQuestionIndex,
          onAnswered: nextQuestion,
          onPrevious: previousQuestion,
          onSubmit: submitAnswers,
          previousAnswer: answers[currentQuestionIndex],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout? Your progress will be lost.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ref.read(userProviderNotifier.notifier).clearUser();
                ref.read(vitalsProviderNotifier.notifier).clearVitals();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onError,
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
