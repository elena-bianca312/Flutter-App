// import 'package:flutter/material.dart';
// import 'package:myproject/services/auth/auth_service.dart';
// import 'package:myproject/services/chat_cloud/cloud_chat_info.dart';
// import 'package:myproject/views/shelters/features/chat/chat_page.dart';
// import 'package:myproject/services/chat_cloud/firebase_chat_storage.dart';

// class ChatList extends StatefulWidget {
//   const ChatList({Key? key}) : super(key: key);

//   @override
//   State<ChatList> createState() => _ChatListState();
// }

// class _ChatListState extends State<ChatList> {
//   late final FirebaseChatStorage _chatService;
//   final currentUser = AuthService.firebase().currentUser!;
//   late final userId = currentUser.id;

//   @override
//   void initState() {
//     _chatService = FirebaseChatStorage();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Chats'),
//       ),
//       body: FutureBuilder<List<Message>>(
//         future: _chatService.getAllChatsForUser(userId),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return const Text('Error');
//           }

//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const CircularProgressIndicator();
//           }

//           final chats = snapshot.data;

//           return ListView.builder(
//             itemCount: chats?.length ?? 0,
//             itemBuilder: (context, index) {
//               final chat = chats![index];

//               return ListTile(
//                 leading: const CircleAvatar(
//                   // Replace with the profile image of the chat
//                   backgroundImage: AssetImage('assets/images/ui/user2.jpg'),
//                 ),
//                 title: Text('Chat${chat.senderId}'),
//                 subtitle: Text(chat.message), // Replace with the last message of the chat
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => ChatPage(recipientId: chat.chatId), // Pass the chat ID to the ChatPage
//                     ),
//                   );
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
