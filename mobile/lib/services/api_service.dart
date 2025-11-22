import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://10.0.2.2:8000";

  static Future<Map<String, dynamic>> processPdf(String path, {bool useOcr = false}) async {
    var uri = Uri.parse("$baseUrl/process-pdf?use_ocr=$useOcr");
    var request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('file', path));
    var response = await request.send();
    return json.decode(await response.stream.bytesToString());
  }

  static Future<Map<String, dynamic>> processText(String text) async {
    final response = await http.post(
      Uri.parse("$baseUrl/process-pdf"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"text": text}),
    );
    return json.decode(response.body);
  }
}
