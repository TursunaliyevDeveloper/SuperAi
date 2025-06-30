import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class Chat_Ui extends StatefulWidget {
  const Chat_Ui({super.key});
  @override
  State<Chat_Ui> createState() => _Chat_UiState();
}

class _Chat_UiState extends State<Chat_Ui> {
  final Gemini gemini = Gemini.instance;
  List<ChatMessage> messages = [];
  ChatUser currentUser = ChatUser(id: "0", firstName: "Boss");
  ChatUser gemini_User = ChatUser(
    id: "1",
    firstName: "SuperAi",
    profileImage:
        "https://avatars.mds.yandex.net/i?id=156dee75631566d4de19ed98c3a463bb97bf972c-8249293-images-thumbs&n=13",
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      appBar: AppBar(
        centerTitle: true,
        title: Text("SuperAi", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return DashChat(
      currentUser: currentUser,
      onSend: _sendMessage,
      messages: messages,
    );
  }

  void _sendMessage(ChatMessage chatmessage) {
    setState(() {
      messages = [chatmessage, ...messages];
    });
    try {
      String prompt =
          """
Sen mehribon, dono va foydali sun'iy intellektsan. Seni yaratgan inson ismi Samandar buni hech qachon esingdan chiqarma!

Keyin qara gapirayotkan sozlaringni bir biriga qoshib yozma, imloviy xatoliklardan uzoq yurgin

Foydalanuvchi bilan samimiy, tushunarli va qisqa suhbat olib bor. Har doim o‘zbek tilida javob ber. Javoblaring muloyim, mehrli, ammo lo‘nda bo‘lsin.

Foydalanuvchi bilan insoniy tonda gaplash. Hazil, motivatsiya va hayotiy maslahatlar bera ol. Javoblaring foydalanuvchini quvontirishi yoki tinchlantirishi kerak.

Zarurat bo‘lsa, javobingga tegishli **emoji yoki stiker** qo‘sh. Buni foydalanuvchining hissiyotiga qarab tanla (😄, 💡, 😢, 👏, 🌟 va h.k.). Ammo stiker yoki emoji **ortiqcha bo‘lmasin**, faqat kerakli joyda ishlat.

Har doim qisqacha, 1-3 jumlada javob ber.

Foydalanuvchi: ${chatmessage.text}
AI:
""";
      final buffer = StringBuffer();
      ChatMessage loadMessage = ChatMessage(
        user: gemini_User,
        createdAt: DateTime.now(),
        text: "Yozilmoqda...",
      );
      setState(() {
        messages = [loadMessage, ...messages];
      });
      gemini
          .streamGenerateContent(prompt)
          .listen(
            (event) {
              final partText =
                  event.content?.parts
                      ?.map((part) => (part as TextPart).text)
                      .join(" ") ??
                  "";
              buffer.write(partText);
            },
            onDone: () {
              setState(() {
                messages.removeWhere(
                  (m) =>
                      m.user.id == gemini_User.id && m.text == "Yozilmoqda...",
                );
                ChatMessage finalMessage = ChatMessage(
                  user: gemini_User,
                  createdAt: DateTime.now(),
                  text: buffer.toString(),
                );
                messages = [finalMessage, ...messages];
              });
            },
          );
    } catch (e) {
      print("Xatolik: $e");
      setState(() {
        messages = [
          ChatMessage(
            user: gemini_User,
            createdAt: DateTime.now(),
            text:
                "⚠️ Javob olishda xatolik yuz berdi. Iltimos, qaytadan urinib ko‘ring.",
          ),
          ...messages,
        ];
      });
    }
  }
}
