import 'package:flutter/material.dart';
import '../services/tts_service.dart';

class VoiceTutorScreen extends StatefulWidget {
  const VoiceTutorScreen({super.key});

  @override
  State<VoiceTutorScreen> createState() => _VoiceTutorScreenState();
}

class _VoiceTutorScreenState extends State<VoiceTutorScreen> {
  bool isLoading = false;
  String transcript = "";
  String aiResponse = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Voice Tutor")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  transcript.isEmpty
                      ? "Voice tutor feature coming soon..."
                      : "You: $transcript",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  aiResponse.isEmpty ? "AI is listening..." : "AI: $aiResponse",
                  style: const TextStyle(
                      fontSize: 16, fontStyle: FontStyle.italic),
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      setState(() => isLoading = true);
                      setState(() {
                        transcript = "Sample question";
                        aiResponse =
                            "This is a sample AI response about your question.";
                      });
                      await TTSService.speak(aiResponse);
                      setState(() => isLoading = false);
                    },
              child: const Text("Demo Mode"),
            ),
          ],
        ),
      ),
    );
  }
}
