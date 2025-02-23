import 'package:file_picker/file_picker.dart';
import 'package:pdf_text/pdf_text.dart';

Future<String> extractTextFromPdf() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom, allowedExtensions: ['pdf']);

  if (result != null) {
    try {
      PDFDoc doc = await PDFDoc.fromPath(result.files.single.path!);
      return await doc.text;
    } catch (e) {
      return "Error extracting text: $e";
    }
  } else {
    return "No file selected!";
  }
} 