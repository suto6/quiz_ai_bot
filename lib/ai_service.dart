import 'package:http/http.dart' as http;
import 'dart:convert';

class AIService {
  static const String apiKey = "YOUR_BOLT_AI_API_KEY";
  static const String apiUrl = "https://api.openai.com/v1/completions";

  Future<String> generateQuestions(String text) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'prompt': 'Generate 5 quiz questions from the following text:\n$text',
          'max_tokens': 200,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['text'];
      } else {
        throw Exception('Failed to generate questions: ${response.statusCode}');
      }
    } catch (e) {
      return "Error generating questions: $e";
    }
  }
} 