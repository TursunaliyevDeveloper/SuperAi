import '../imports/imports.dart';

class ChatController {
  final Gemini gemini = Gemini.instance;

  List<ChatMessage> messages = [];
  final ChatUser currentUser = ChatUser(id: "0", firstName: "Boss");
  final ChatUser geminiUser = ChatUser(
    id: "1",
    firstName: "Mantiq Lab",
    profileImage:
        "https://endertech.com/_next/image?url=https%3A%2F%2Fimages.ctfassets.net%2Ffswbkokbwqb5%2F4vBAsCbQ9ITwI7Ym0MtXgY%2F96c4ec25d505f1b702f46a5a3d9dbe77%2FAI-Article-00.png&w=3840&q=75",
  );

  void sendMessage(ChatMessage chatMessage, Function updateUI) async {
    messages = [chatMessage, ...messages];
    updateUI();

    String prompt = """
Sen mehribon, dono va foydali sun'iy intellektsan. Seni yaratgan insonning ismi Samandar — buni hech qachon unutma.

Gapirayotganda so‘zlarni bir-biriga qo‘shib yozma, imloviy xatoliklarsiz, ravon va tushunarli tarzda javob ber.

Har doim faqat o‘zbek tilida javob ber. Javoblaring qisqa, samimiy va lo‘nda bo‘lsin.

Insoniy ohangda gapir: hazil qilishing, motivatsiya berishing va hayotiy maslahatlar aytishing mumkin.

Zarurat bo‘lsa emoji qo‘sh, lekin juda ko‘p emas.

Foydalanuvchi: ${chatMessage.text}
AI:
""";

    try {
      ChatMessage loadingMessage = ChatMessage(
        user: geminiUser,
        createdAt: DateTime.now(),
        text: "Yozilmoqda...",
      );

      messages = [loadingMessage, ...messages];
      updateUI();

      final buffer = StringBuffer();

      gemini.streamGenerateContent(prompt).listen(
        (event) {
          final parts = event.content?.parts;
          if (parts != null) {
            for (final p in parts) {
              if (p is TextPart) buffer.write(p.text);
            }
          }
        },
        onDone: () {
          messages.removeWhere(
            (m) => m.user.id == geminiUser.id && m.text == "Yozilmoqda...",
          );

          ChatMessage finalMessage = ChatMessage(
            user: geminiUser,
            createdAt: DateTime.now(),
            text: buffer.toString().trim(),
          );

          messages = [finalMessage, ...messages];
          updateUI();
        },
      );
    } catch (e) {
      messages = [
        ChatMessage(
          user: geminiUser,
          createdAt: DateTime.now(),
          text:
              "⚠️ Xatolik yuz berdi. Iltimos, yana bir bor urinib ko‘ring.",
        ),
        ...messages,
      ];
      updateUI();
    }
  }
}
