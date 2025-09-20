import 'package:flutter/material.dart';
import 'package:neura_care/models/question.dart';
import "package:neura_care/data/onboarding_questions.dart";

class OnboardingQuestion extends StatefulWidget {
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
  State<OnboardingQuestion> createState() => _OnboardingQuestionState();
}

class _OnboardingQuestionState extends State<OnboardingQuestion> {
  String? selectedValue;
  late final TextEditingController controller;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(
      text: (widget.previousAnswer ?? '').toString(),
    );
    
    // Initialize selectedValue for choice questions
    final question = onboardingQuestions[widget.currentIndex];
    if (question.type == QuestionType.choice) {
      selectedValue = widget.previousAnswer != null
          ? widget.previousAnswer.toString()
          : question.options!.first;
      
      // Ensure the selected value exists in options
      if (!question.options!.contains(selectedValue)) {
        selectedValue = question.options!.first;
      }
    }
  }

  @override
  void didUpdateWidget(OnboardingQuestion oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // If we moved to a different question, update the state
    if (oldWidget.currentIndex != widget.currentIndex || oldWidget.previousAnswer != widget.previousAnswer) {
      controller.text = (widget.previousAnswer ?? '').toString();
      
      // Update selectedValue for choice questions
      final question = onboardingQuestions[widget.currentIndex];
      if (question.type == QuestionType.choice) {
        final newSelectedValue = widget.previousAnswer != null
            ? widget.previousAnswer.toString()
            : question.options!.first;
        
        // Ensure the selected value exists in options
        if (question.options!.contains(newSelectedValue)) {
          selectedValue = newSelectedValue;
        } else {
          selectedValue = question.options!.first;
        }
      }
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final question = onboardingQuestions[widget.currentIndex];
    final isLastQuestion = widget.currentIndex == onboardingQuestions.length - 1;
    final isFirstQuestion = widget.currentIndex == 0;

    late final Widget questionWidget;
    
    if (question.type == QuestionType.choice) {
      questionWidget = Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(color: theme.colorScheme.outline),
          borderRadius: BorderRadius.circular(12),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selectedValue,
            isExpanded: true,
            icon: Icon(Icons.keyboard_arrow_down, color: theme.colorScheme.onSurface),
            items: question.options!
                .map((option) => DropdownMenuItem(
                      value: option,
                      child: Text(
                        option,
                        style: theme.textTheme.bodyLarge,
                      ),
                    ))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  selectedValue = value;
                });
              }
            },
          ),
        ),
      );
    } else if (question.type == QuestionType.text) {
      questionWidget = TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: 'Your answer',
          hintText: 'Enter your response',
          prefixIcon: const Icon(Icons.edit_outlined),
        ),
        onFieldSubmitted: (value) {
          if (_formKey.currentState!.validate()) {
            widget.onAnswered(value);
          }
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a value';
          }
          return null;
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        textCapitalization: TextCapitalization.sentences,
      );
    } else {
      IconData prefixIcon = Icons.numbers;
      String hintText = 'Enter a number';
      
      if (question.text.toLowerCase().contains('age')) {
        prefixIcon = Icons.cake_outlined;
        hintText = 'Enter your age';
      } else if (question.text.toLowerCase().contains('weight')) {
        prefixIcon = Icons.monitor_weight_outlined;
        hintText = 'Enter weight in kg';
      } else if (question.text.toLowerCase().contains('height')) {
        prefixIcon = Icons.height_outlined;
        hintText = 'Enter height in cm';
      } else if (question.text.toLowerCase().contains('pressure')) {
        prefixIcon = Icons.favorite_outlined;
        hintText = 'Enter blood pressure';
      } else if (question.text.toLowerCase().contains('heart')) {
        prefixIcon = Icons.monitor_heart_outlined;
        hintText = 'Enter heart rate (bpm)';
      } else if (question.text.toLowerCase().contains('sugar')) {
        prefixIcon = Icons.water_drop_outlined;
        hintText = 'Enter blood sugar level';
      } else if (question.text.toLowerCase().contains('cholesterol')) {
        prefixIcon = Icons.bloodtype_outlined;
        hintText = 'Enter cholesterol level';
      } else if (question.text.toLowerCase().contains('sleep')) {
        prefixIcon = Icons.bedtime_outlined;
        hintText = 'Enter hours of sleep';
      }
      
      questionWidget = TextFormField(
        controller: controller,
        keyboardType: question.type == QuestionType.int
            ? TextInputType.number
            : const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: 'Your answer',
          hintText: hintText,
          prefixIcon: Icon(prefixIcon),
        ),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Question Title
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            question.text,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Question Input
        Form(
          key: _formKey,
          child: questionWidget,
        ),
        
        const SizedBox(height: 32),
        
        // Navigation Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Previous Button
            if (!isFirstQuestion)
              SizedBox(
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: widget.onPrevious,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Previous'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                  ),
                ),
              )
            else
              const SizedBox.shrink(),
            
            // Next/Submit Button
            SizedBox(
              height: 48,
              child: isLastQuestion
                  ? ElevatedButton.icon(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          widget.onSubmit(getAnswer());
                        }
                      },
                      icon: const Icon(Icons.check),
                      label: const Text('Submit'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                      ),
                    )
                  : ElevatedButton.icon(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          widget.onAnswered(getAnswer());
                        }
                      },
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('Next'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                      ),
                    ),
            ),
          ],
        ),
      ],
    );
  }
}
