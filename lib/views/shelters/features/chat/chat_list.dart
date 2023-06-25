import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myproject/widgets/background_image.dart';
import 'package:myproject/services/auth/auth_service.dart';
import 'package:myproject/views/shelters/features/chat/chat_page.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final currentUser = AuthService.firebase().currentUser!;
  late final userId = currentUser.email;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const BackgroundImage(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('Chats'),
            backgroundColor: Colors.transparent,
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
                  return Column(
                    children: [
                      const Divider(
                        color: Colors.white,
                        thickness: 1.0,
                      ),
                      ListTile(
                        leading: const CircleAvatar(
                          radius: 18.0,
                          backgroundImage: AssetImage('assets/images/ui/contact_3.png',),
                        ),
                        title: Text('Chat with $recipientId', style: const TextStyle(color: Colors.white),),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatPage(recipientId: recipientId),
                            ),
                          );
                        },
                      ),
                      if (index == userDocs.length - 1)
                        const Divider(
                          color: Colors.white,
                          thickness: 1.0,
                        ),
                    ],
                  );
                },
              );
            },
          ),
        )
      ],
    );
  }
}
