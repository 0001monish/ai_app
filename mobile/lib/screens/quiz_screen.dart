// mobile/lib/screens/quiz_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/question.dart';
import '../logic/adaptive_logic.dart';
import '../services/tts_service.dart';

class QuizScreen extends ConsumerStatefulWidget {
  final String pdfId;
  final List<Question> questions;
  const QuizScreen({super.key, required this.pdfId, required this.questions});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  int currentIndex = 0;
  String? selectedAnswer;
  bool showResult = false;
  List<bool> results = [];

  @override
  Widget build(BuildContext context) {
    final question = widget.questions[currentIndex];
    final progress = (currentIndex + 1) / widget.questions.length;

    return Scaffold(
      appBar: AppBar(title: const Text("AI Quiz")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            LinearProgressIndicator(value: progress, minHeight: 8),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Q${currentIndex + 1}: ${question.questionText}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...question.options.map(
                      (opt) => RadioListTile<String>(
                        title: Text(opt),
                        value: opt,
                        groupValue: selectedAnswer,
                        onChanged: showResult
                            ? null
                            : (val) => setState(() => selectedAnswer = val),
                      ),
                    ),
                    if (showResult)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color:
                              results.last ? Colors.green[50] : Colors.red[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          results.last
                              ? "Correct! ${question.explanation}"
                              : "Wrong. Correct: ${question.correctAnswer}\n${question.explanation}",
                          style: TextStyle(
                            color: results.last
                                ? Colors.green[800]
                                : Colors.red[800],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _nextQuestion,
              child: Text(showResult ? "Next" : "Submit"),
            ),
          ],
        ),
      ),
    );
  }

  void _nextQuestion() async {
    if (!showResult && selectedAnswer != null) {
      final correct =
          selectedAnswer == widget.questions[currentIndex].correctAnswer;
      results.add(correct);
      setState(() => showResult = true);
      if (correct)
        await TTSService.speak("Correct!");
      else
        await TTSService.speak("Wrong. Let's learn.");
      return;
    }

    if (currentIndex < widget.questions.length - 1) {
      setState(() {
        currentIndex++;
        selectedAnswer = null;
        showResult = false;
      });
    } else {
      _finishQuiz();
    }
  }

  void _finishQuiz() async {
    final accuracy = results.where((r) => r).length / results.length;
    final feedback = AdaptiveLogic.getFeedback(accuracy);

    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(feedback)));
      Navigator.pop(context);
    }
  }
}
