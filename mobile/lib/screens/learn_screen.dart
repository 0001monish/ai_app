// mobile/lib/screens/learn_screen.dart
import 'package:flutter/material.dart';
import '../widgets/pdf_card.dart';
import 'quiz_screen.dart';

class LearnScreen extends StatefulWidget {
  const LearnScreen({super.key});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Library")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          PdfCard(
            title: "Sample Textbook - Chapter 1",
            date: DateTime.now(),
            isPremium: false,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const QuizScreen(pdfId: "1", questions: []),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          PdfCard(
            title: "Advanced Topics",
            date: DateTime.now().subtract(const Duration(days: 1)),
            isPremium: true,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const QuizScreen(pdfId: "2", questions: []),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          const Center(
            child: Text(
              "Upload or scan PDFs to expand your library",
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
