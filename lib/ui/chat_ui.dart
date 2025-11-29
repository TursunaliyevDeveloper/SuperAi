import '../imports/imports.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatController controller = ChatController();
  final Color _backgroundColor = Colors.blueAccent;

  void updateUI() {
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Mantiq Lab", style: TextStyle(color: Colors.white)),
        backgroundColor: _backgroundColor,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: DashChat(
            currentUser: controller.currentUser,
            messages: controller.messages,
            onSend: (ChatMessage message) {
              controller.sendMessage(message, updateUI);
            },
            messageOptions: MessageOptions(currentUserTextColor: Colors.white),
            inputOptions: InputOptions(
              inputDecoration: InputDecoration(
                hintText: "Savolingizni yozing...",
                fillColor: Colors.white,
                filled: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
              sendButtonBuilder: (onSend) {
                return IconButton(
                  onPressed: onSend,
                  icon: const Icon(Icons.send, color: Colors.white),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
