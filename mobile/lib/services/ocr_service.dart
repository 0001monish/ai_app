import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class OcrService {
  static final _recognizer = TextRecognizer();

  static Future<String> scanPhoto() async {
    final picker = ImagePicker();
    final photo = await picker.pickImage(source: ImageSource.camera);
    if (photo == null) return "";
    final inputImage = InputImage.fromFilePath(photo.path);
    final recognizedText = await _recognizer.processImage(inputImage);
    return recognizedText.text;
  }
}
