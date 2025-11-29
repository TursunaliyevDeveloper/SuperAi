import 'imports/imports.dart';

void main() {
  Gemini.init(apiKey: Gemini_Ai_Api_Key);
  runApp(const MaterialApp(
    home: ChatScreen(),
    debugShowCheckedModeBanner: false,
  ));
}
