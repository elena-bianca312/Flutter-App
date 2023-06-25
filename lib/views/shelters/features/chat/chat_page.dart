import 'package:flutter/material.dart';
import 'package:myproject/services/auth/auth_service.dart';
import 'package:myproject/services/chat_cloud/cloud_chat_info.dart';
import 'package:myproject/services/chat_cloud/firebase_chat_storage.dart';

class ChatPage extends StatefulWidget {
  final String recipientId;

  const ChatPage({Key? key, required this.recipientId}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<Message> _messages = [];

  final FirebaseChatStorage _chatStorage = FirebaseChatStorage();
  final currentUser = AuthService.firebase().currentUser!;
  late final userId = currentUser.id;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    List<Message> messages = await _chatStorage.getChatMessages(userId, widget.recipientId);
    setState(() {
      _messages.clear();
      _messages.addAll(messages);
    });
  }

  void _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      DateTime now = DateTime.now();
      Message newMessage = Message(
        message: _messageController.text,
        senderId: userId,
        timestamp: now,
      );

      await _chatStorage.createNewChat(currentUserId: userId, recipientUserId: widget.recipientId);
      await _chatStorage.addMessageToChat(userId, widget.recipientId, newMessage);

      setState(() {
        _messages.add(newMessage);
        _messageController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                Message message = _messages[index];
                return ListTile(
                  title: Text(message.message),
                  subtitle: Text(message.timestamp.toString()),
                  tileColor: Colors.blue.withOpacity(0.1),
                  trailing: const Icon(Icons.check),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
