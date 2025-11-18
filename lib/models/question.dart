class Question {
  final String question;
  final List<String> options;
  final String correctAnswer;

  Question({
    required this.question,
    required this.options,
    required this.correctAnswer,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    List<String> options =
        List<String>.from(json['Incorrect_answers']);
    options.add(json['Correct_answer']);
    options.shuffle();

    return Question(
      question: json['Question'],
      options: options,
      correctAnswer: json['Correct_answer'],
    );
  }
}
