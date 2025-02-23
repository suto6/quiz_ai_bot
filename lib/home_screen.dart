import 'package:flutter/material.dart';
import 'package:quiz_ai_bot/pdf_processor.dart';
import 'package:quiz_ai_bot/ai_service.dart';
import 'package:quiz_ai_bot/voice_service.dart';
import 'package:quiz_ai_bot/tts_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  String extractedText = "";
  String generatedQuestions = "";
  bool _isListening = false;

  final VoiceService voiceService = VoiceService();
  final TTSService ttsService = TTSService();
  final AIService aiService = AIService();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startFadeAnimation() {
    _animationController.reset();
    _animationController.forward();
  }

  Future<void> _uploadPdf() async {
    extractedText = await extractTextFromPdf();
    setState(() {});
    _startFadeAnimation();
  }

  Future<void> _generateQuestions() async {
    generatedQuestions = await aiService.generateQuestions(extractedText);
    setState(() {});
    _startFadeAnimation();
  }

  Future<void> _voiceInput() async {
    final speechResult = await voiceService.listen();
    setState(() {
      extractedText = speechResult;
      _isListening = voiceService.isListening();
    });
    _startFadeAnimation();
  }

  Future<void> _voiceOutput() async {
    await ttsService.speak(generatedQuestions);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Dark background
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Row(
          children: [
            // Logo or Icon (Optional)
            // Icon(Icons.document_scanner, color: Color(0xfffa3c75)),
            // SizedBox(width: 8),
            Text(
              "AI DOC",
              style: TextStyle(
                color: Color(0xfffa3c75),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // PDF Preview Section (Mocked)
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      "Start Up Supply Chain Management",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    // "2/5" with left-right arrows
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chevron_left, color: Color(0xfffa3c75)),
                        Text(
                          "2/5",
                          style: TextStyle(
                            color: Color(0xfffa3c75),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(Icons.chevron_right, color: Color(0xfffa3c75)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Four Actions (Lock, Annotate, Layout, eSign)
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
                children: [
                  _buildActionTile(
                    icon: Icons.lock,
                    label: "Lock",
                    onTap: () {
                      // Example: lock functionality
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Lock feature tapped")),
                      );
                    },
                  ),
                  _buildActionTile(
                    icon: Icons.edit_note,
                    label: "Annotate",
                    onTap: () {
                      // Example: annotate functionality
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Annotate feature tapped")),
                      );
                    },
                  ),
                  _buildActionTile(
                    icon: Icons.view_agenda_outlined,
                    label: "Layout",
                    onTap: () {
                      // Example: layout functionality
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Layout feature tapped")),
                      );
                    },
                  ),
                  _buildActionTile(
                    icon: Icons.draw,
                    label: "eSign",
                    onTap: () {
                      // Example: eSign functionality
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("eSign feature tapped")),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Download PDF Button
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    // Example: download functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Download PDF tapped")),
                    );
                  },
                  child: Text("Download PDF"),
                ),
              ),
              const SizedBox(height: 32),

              // --- Existing QuizAIBot Features Below ---

              // Upload PDF
              ElevatedButton(
                onPressed: _uploadPdf,
                child: const Text("Select PDF (Extract Text)"),
              ),
              // Generate Questions
              ElevatedButton(
                onPressed: _generateQuestions,
                child: const Text("Generate AI Questions"),
              ),
              // Voice Input
              ElevatedButton(
                onPressed: _voiceInput,
                child: Text(_isListening ? "Listening..." : "Voice Input"),
              ),
              // Voice Output
              ElevatedButton(
                onPressed: _voiceOutput,
                child: const Text("Voice Output"),
              ),

              const SizedBox(height: 20),
              // Display Extracted Text
              Text(
                "Extracted Text:",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.only(top: 4.0),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  extractedText,
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              // Display AI Generated Questions
              Text(
                "AI Generated Questions:",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.only(top: 4.0),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  generatedQuestions,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Color(0xfffa3c75)),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: Color(0xfffa3c75),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
