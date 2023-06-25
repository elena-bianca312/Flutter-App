import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:myproject/styles/styles.dart';
import 'package:myproject/widgets/background_image.dart';
import 'package:myproject/services/auth/auth_service.dart';
import 'package:myproject/services/chat_cloud/cloud_chat_info.dart';
import 'package:myproject/services/chat_cloud/firebase_chat_storage.dart';

class ChatPage extends StatefulWidget {
  final String recipientId;

  const ChatPage({Key? key, required this.recipientId}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<Message> _messages = [];

  final FirebaseChatStorage _chatStorage = FirebaseChatStorage();
  final currentUser = AuthService.firebase().currentUser!;
  late final userId = currentUser.email;

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
    return Stack(
      children: [
        const BackgroundImage(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Text(widget.recipientId, style: const TextStyle(fontSize: 18),),
              backgroundColor: Colors.transparent,
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      Message message = _messages[_messages.length - index - 1];
                      bool isCurrentUser = message.senderId == userId;
                      return Align(
                        alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: isCurrentUser ? kCustomBlue : Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                message.message,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: isCurrentUser ? Colors.black : Colors.black,
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                "${DateFormat('yyyy-MM-dd').format(message.timestamp)} - ${DateFormat('HH:mm:ss').format(message.timestamp)}",
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: isCurrentUser ? Colors.black45 : Colors.black45,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          style: const TextStyle(color: Colors.white),
                          controller: _messageController,
                          decoration: const InputDecoration(
                            hintText: 'Type a message',
                            hintStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(24.0)),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send, color: Colors.white,),
                        onPressed: _sendMessage,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
