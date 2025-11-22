import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/record_service.dart';
import '../services/tts_service.dart';
import '../utils/constants.dart';

class VoiceTutorScreen extends StatefulWidget {
  const VoiceTutorScreen({super.key});

  @override
  State<VoiceTutorScreen> createState() => _VoiceTutorScreenState();
}

class _VoiceTutorScreenState extends State<VoiceTutorScreen> {
  bool isRecording = false;
  bool isLoading = false;
  String transcript = "";
  String aiResponse = "";
  String? recordingPath;

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
                  transcript.isEmpty ? "Tap mic to speak..." : "You: $transcript",
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
                  style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                ),
              ),
            ),
            const Spacer(),
            FloatingActionButton(
              onPressed: isLoading ? null : _toggleRecording,
              child: Icon(isRecording ? Icons.stop : Icons.mic),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleRecording() async {
    if (isRecording) {
      setState(() => isLoading = true);
      final file = await RecordService.stopRecording();
      if (file != null) {
        await _sendToBackend(file);
      }
      setState(() {
        isRecording = false;
        isLoading = false;
      });
    } else {
      final path = await RecordService.startRecording();
      if (path != null) {
        setState(() => isRecording = true);
      }
    }
  }

  Future<void> _sendToBackend(File audioFile) async {
    final uri = Uri.parse("${AppConstants.baseUrl}/voice-query");
    final request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('audio', audioFile.path));
    final response = await request.send();
    final resp = json.decode(await response.stream.bytesToString());

    setState(() {
      transcript = resp['user_text'];
      aiResponse = resp['ai_response'];
    });

    await TTSService.speak(aiResponse);
  }
}
