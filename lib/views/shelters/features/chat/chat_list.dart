import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myproject/services/auth/auth_service.dart';
import 'package:myproject/views/shelters/features/chat/chat_page.dart';

class ChatList extends StatefulWidget {
  const ChatList({Key? key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final currentUser = AuthService.firebase().currentUser!;
  late final userId = currentUser.id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .doc(userId)
            .collection('users')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Error');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          final userDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: userDocs.length,
            itemBuilder: (context, index) {
              final userDoc = userDocs[index];
              final recipientId = userDoc.id;

              return ListTile(
                leading: const CircleAvatar(
                  // Replace with the profile image of the chat
                  backgroundImage: AssetImage('assets/images/ui/user2.jpg'),
                ),
                title: Text('Chat with $recipientId'),
                // subtitle: const Text('Last message'), // Replace with the last message of the chat
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatPage(recipientId: recipientId), // Pass the recipient's ID to the ChatPage
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
