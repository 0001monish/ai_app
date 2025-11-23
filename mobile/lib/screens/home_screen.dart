import 'package:flutter/material.dart';
import '../widgets/pdf_card.dart';
import '../widgets/animated_card.dart';
import 'premium_screen.dart';
import 'quiz_screen.dart';
import 'voice_tutor_screen.dart';
import 'learn_screen.dart';
import 'progress_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("IntelliLearn")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AnimatedCard(
            child: const Text(
              "Welcome! Upload or scan to learn.",
              style: TextStyle(fontSize: 18),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("PDF upload feature coming soon!"),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            icon: const Icon(Icons.upload),
            label: const Text("Upload PDF"),
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Scan feature coming soon!"),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            icon: const Icon(Icons.camera_alt),
            label: const Text("Scan Page"),
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
          ),
          const SizedBox(height: 24),
          // NAVIGATION BUTTONS
          ElevatedButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LearnScreen()),
            ),
            icon: const Icon(Icons.library_books),
            label: const Text("My Library"),
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProgressScreen()),
            ),
            icon: const Icon(Icons.bar_chart),
            label: const Text("Progress"),
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
          ),
          const SizedBox(height: 24),
          PdfCard(
            title: "Sample Textbook",
            date: DateTime.now(),
            onTap: () {},
            isPremium: true,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const QuizScreen(pdfId: "1", questions: []),
              ),
            ),
            icon: const Icon(Icons.quiz),
            label: const Text("Start Quiz"),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => VoiceTutorScreen()),
            ),
            icon: const Icon(Icons.record_voice_over),
            label: const Text("Voice Tutor"),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => PremiumScreen()),
            ),
            icon: const Icon(Icons.star),
            label: const Text("Go Premium"),
          ),
        ],
      ),
    );
  }
}
