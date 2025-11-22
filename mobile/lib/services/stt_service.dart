import 'package:record/record.dart';
import 'dart:io';

class STTService {
  static final _record = AudioRecorder();

  static Future<String?> startRecording() async {
    if (await _record.hasPermission()) {
      final path = '${Directory.systemTemp.path}/voice_${DateTime.now().millisecondsSinceEpoch}.wav';
      await _record.start(const RecordConfig(), path: path);
      return path;
    }
    return null;
  }

  static Future<File?> stopRecording() async {
    final path = await _record.stop();
    return path != null ? File(path) : null;
  }
}