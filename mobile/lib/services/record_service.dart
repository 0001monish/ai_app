import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class RecordService {
  static final _recorder = AudioRecorder();

  static Future<String?> startRecording() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final filePath = "${dir.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a";
      await _recorder.start(
        RecordConfig(encoder: AudioEncoder.aacLc),
        path: filePath,
      );
      return filePath;
    } catch (e) {
      // Error starting recording
      return null;
    }
  }

  static Future<File?> stopRecording() async {
    try {
      final path = await _recorder.stop();
      return path != null ? File(path) : null;
    } catch (e) {
      // Error stopping recording
      return null;
    }
  }
}
