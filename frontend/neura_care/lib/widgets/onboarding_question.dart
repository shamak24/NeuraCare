import 'package:flutter/material.dart';
import 'package:neura_care/models/question.dart';
import "package:neura_care/data/onboarding_questions.dart";

class OnboardingQuestion extends StatelessWidget {
  final Function(String) onAnswered;
  final Function() onPrevious;
  final Function(String) onSubmit;
  final int currentIndex;
  final dynamic previousAnswer;

  const OnboardingQuestion({
    super.key,
    required this.onAnswered,
    required this.onPrevious,
    required this.onSubmit,
    required this.currentIndex,
    required this.previousAnswer,
  });

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final question = onboardingQuestions[currentIndex];
    final isLastQuestion = currentIndex == onboardingQuestions.length - 1;
    final isFirstQuestion = currentIndex == 0;

    final TextEditingController controller = TextEditingController(
      text: (previousAnswer ?? '').toString(),
    );
    String? selectedValue;
    late final Widget questionWidget;
    if (question.type == QuestionType.choice) {
      // Ensure we use a string and that it exists in options
      selectedValue = previousAnswer != null
          ? previousAnswer.toString()
          : question.options!.first;
      final String initialSelection = question.options!.contains(selectedValue)
          ? selectedValue
          : question.options!.first;

      questionWidget = DropdownMenu<String>(
        dropdownMenuEntries: question.options!
            .map((e) => DropdownMenuEntry(value: e, label: e))
            .toList(),
        onSelected: (value) {
          if (value != null) {
            selectedValue = value;
          }
        },
        initialSelection: initialSelection,
      );
    } else if (question.type == QuestionType.text) {
      questionWidget = TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: 'Your answer'),
        onFieldSubmitted: (value) {
          onAnswered(value);
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a value';
          }
          return null;
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
      );
    } else {
      questionWidget = TextFormField(
        controller: controller,
        keyboardType: question.type == QuestionType.int
            ? TextInputType.number
            : TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(labelText: 'Your answer'),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a value';
          }
          if (question.type == QuestionType.int) {
            if (int.tryParse(value) == null) {
              return 'Please enter a valid integer';
            }
          } else if (question.type == QuestionType.double) {
            if (double.tryParse(value) == null) {
              return 'Please enter a valid number';
            }
          }
          return null;
        },
      );
    }

    String getAnswer() {
      if (question.type == QuestionType.choice) {
        return selectedValue ?? '';
      }
      return controller.text;
    }

    return Column(
      children: [
        Text(question.text),
        Form(key: _formKey, child: questionWidget),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (!isFirstQuestion)
              ElevatedButton(
                onPressed: onPrevious,
                child: const Text('Previous'),
              ),
            if (!isLastQuestion)
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    onAnswered(getAnswer());
                  }
                },
                child: const Text('Next'),
              ),
            if (isLastQuestion)
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    onSubmit(getAnswer());
                  }
                },
                child: const Text('Submit'),
              ),
          ],
        ),
      ],
    );
  }
}
