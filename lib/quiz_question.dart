class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctOptionIndex;
  final String backgroundImage;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctOptionIndex,
    required this.backgroundImage,
  });
}
