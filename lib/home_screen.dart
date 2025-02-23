import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

void main() {
  runApp(AIQuizApp());
}

class AIQuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.teal,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String extractedText = "";
  FlutterTts flutterTts = FlutterTts();
  stt.SpeechToText speechToText = stt.SpeechToText();
  bool isListening = false;
  String userInput = "";
  bool isLoading = false;

  Future<void> pickPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null) {
      File file = File(result.files.single.path!);
      setState(() {
        extractedText = "Sample extracted text from PDF.";
      });
    }
  }

  Future<void> generateQuestions() async {
    setState(() {
      isLoading = true;
    });

    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/completions'),
      headers: {
        'Authorization': 'Bearer YOUR_OPENAI_API_KEY',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "model": "gpt-3.5-turbo",
        "prompt": "Generate 5 quiz questions from the following text: $extractedText",
        "max_tokens": 200,
      }),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        extractedText = data['choices'][0]['text'];
        isLoading = false;
      });
    }
  }

  void startListening() async {
    bool available = await speechToText.initialize();
    if (available) {
      setState(() {
        isListening = true;
      });
      speechToText.listen(onResult: (result) {
        setState(() {
          userInput = result.recognizedWords;
        });
      });
    }
  }

  void stopListening() {
    setState(() {
      isListening = false;
    });
    speechToText.stop();
  }

  void speakText(String text) async {
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("AI Quiz Generator")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/ai_animation.json', height: 150),
            SizedBox(height: 20),
            AnimatedOpacity(
              duration: Duration(milliseconds: 500),
              opacity: isLoading ? 0.5 : 1.0,
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: pickPDF,
                    child: Text("Pick PDF"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: generateQuestions,
                    child: Text("Generate Questions"),
                  ),
                  SizedBox(height: 10),
                  if (isLoading)
                    CircularProgressIndicator(),
                  if (!isLoading)
                    AnimatedContainer(
                      duration: Duration(milliseconds: 600),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.teal.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        extractedText,
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: isListening ? stopListening : startListening,
                    child: Text(isListening ? "Stop Listening" : "Start Listening"),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "User Input: $userInput",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => speakText(extractedText),
                    child: Text("Read Aloud"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
