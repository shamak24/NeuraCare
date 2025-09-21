import 'package:neura_care/models/question.dart';

final List<Question> onboardingQuestions = [
  Question(text: 'What is your age? (in years)', type: QuestionType.int, options: []),
  Question(
    text: 'What is your gender?',
    type: QuestionType.choice,
    options: ['Male', 'Female', 'Other'],
  ),
  Question(
    text: "What is your Systolic blood pressure? (in mmHg)",
    type: QuestionType.int,
  ),
  Question(
    text: "What is your Diastolic blood pressure? (in mmHg)",
    type: QuestionType.int,
  ),
  Question(text: "What is your heartRate? (in bpm)", type: QuestionType.int),
  Question(text: "What is your Blood sugar level? (in mg/dL)", type: QuestionType.int),
  Question(text: "What is your weight? (in kg)", type: QuestionType.double),
  Question(text: "What is your cholesterol? (in mg/dL)", type: QuestionType.int),
  Question(
    text: 'What is your activity level?',
    type: QuestionType.choice,
    options: ["Sedentary", "Lightly Active", "Active", "Very Active"],
  ),
  Question(text: "What is your height? (in cm)", type: QuestionType.double),
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
  Question(text: "How many hours do you sleep? (in hours)", type: QuestionType.double),
];
