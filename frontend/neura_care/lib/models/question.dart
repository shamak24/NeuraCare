enum QuestionType{
  text,
  double,
  int,
  choice,
}


class Question {
  final String text;
  final QuestionType type;
  final List<String>? options; 
  Question({
    required this.text,
    required this.type,
    this.options,
  });
}