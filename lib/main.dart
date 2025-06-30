import 'package:SuperAi/presentation/chat_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'domain/consts.dart';

void main() {
  Gemini.init(apiKey: Gemini_Ai_Api_Key);
  runApp(MaterialApp(home: Chat_Ui(), debugShowCheckedModeBanner: false));
}

class Main_Page extends StatelessWidget {
  const Main_Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Chat_Ui();
  }
}
