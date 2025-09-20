import 'package:neura_care/models/question.dart';

final List<Question> onboardingQuestions = [
  Question(text: 'What is your age?', type: QuestionType.int, options: []),
  Question(
    text: 'What is your gender?',
    type: QuestionType.choice,
    options: ['Male', 'Female', 'Other'],
  ),
  Question(
    text: "What is your Systolic blood pressure?",
    type: QuestionType.int,
  ),
  Question(
    text: "What is your Diastolic blood pressure?",
    type: QuestionType.int,
  ),
  Question(text: "What is your heartRate", type: QuestionType.int),
  Question(text: "What is your sugarLevel", type: QuestionType.int),
  Question(text: "What is your weight", type: QuestionType.double),
  Question(text: "What is your cholesterol", type: QuestionType.int),
  Question(
    text: 'What is your activity level?',
    type: QuestionType.choice,
    options: ["Sedentary", "Lightly Active", "Active", "Very Active"],
  ),
  Question(text: "What is your height", type: QuestionType.double),
  Question(
    text: "Do you smoke?",
    type: QuestionType.choice,
    options: ["false", "true"],
  ),
  Question(
    text: "Do you drink alcohol?",
    type: QuestionType.choice,
    options: ["false", "true"],
  ),
  Question(text: "How many hours do you sleep?", type: QuestionType.double),
];
