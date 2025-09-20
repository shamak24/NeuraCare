import 'package:neura_care/models/question.dart';

final List<Question> onboardingQuestions = [
  Question(text: 'What is your age?', type: QuestionType.int, options: []),
  Question(
    text: 'What is your gender?',
    type: QuestionType.choice,
    options: ['Male', 'Female', 'Other'],
  ),
  Question(text: "What is your bloodPressure", type: QuestionType.double),
  Question(text: "What is your heartRate", type: QuestionType.int),
  Question(text: "What is your sugarLevel", type: QuestionType.double),
  Question(text: "What is your weight", type: QuestionType.double),
  Question(text: "What is your cholesterol", type: QuestionType.double),
  Question(
    text: 'What is your activity level?',
    type: QuestionType.choice,
    options: ["Sedentary", "Lightly Active", "Active", "Very Active"],
  ),
];
