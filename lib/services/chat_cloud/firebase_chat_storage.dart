import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myproject/services/chat_cloud/cloud_chat_info.dart';
import 'package:myproject/services/chat_cloud/cloud_chat_exceptions.dart';

class FirebaseChatStorage {
  FirebaseChatStorage._sharedInstance();
  static final FirebaseChatStorage _shared = FirebaseChatStorage._sharedInstance();
  factory FirebaseChatStorage() {
    return _shared;
  }

  final chats = FirebaseFirestore.instance.collection('chats');

  Future<void> createNewChat({required String currentUserId, required String recipientUserId}) async {
    try {
      final currentChatRef = chats.doc(currentUserId).collection('users').doc(recipientUserId);
      final recipientChatRef = chats.doc(recipientUserId).collection('users').doc(currentUserId);

      final currentChatSnapshot = await currentChatRef.get();
      final recipientChatSnapshot = await recipientChatRef.get();

      if (!currentChatSnapshot.exists) {
        currentChatRef.set({
          'messages': [],
        });
      }

      if (!recipientChatSnapshot.exists) {
        recipientChatRef.set({
          'messages': [],
        });
      }
    } catch (e) {
      throw ErrorCreatingChatException();
    }
  }

  Future<void> addMessageToChat(String senderUserId, String recipientUserId, Message message) async {
    try {
      final currentChatRef = chats.doc(senderUserId).collection('users').doc(recipientUserId);
      final recipientChatRef = chats.doc(recipientUserId).collection('users').doc(senderUserId);

      await currentChatRef.update({
        'messages': FieldValue.arrayUnion([message.toJson()]),
      });

      await recipientChatRef.update({
        'messages': FieldValue.arrayUnion([message.toJson()]),
      });
    } catch (e) {
      throw ErrorAddingMessageToChatException();
    }
  }

  Future<List<Message>> getChatMessages(String currentUserId, String recipientUserId) async {
    try {
      final currentChatRef = chats.doc(currentUserId).collection('users').doc(recipientUserId);

      final currentChatSnapshot = await currentChatRef.get();
      final chatData = currentChatSnapshot.data();

      if (chatData != null) {
        final List<Message> messages =
            (chatData['messages'] as List<dynamic>?)?.map((data) => Message.fromJson(data)).toList() ?? [];

        return messages;
      } else {
        return [];
      }
    } catch (e) {
      throw ErrorFetchingMessagesException();
    }
  }

  Future<List<Message>> getAllChatsForUser(String userId) async {
    try {
      final userChatsSnapshot = await chats.doc(userId).collection('users').get();
      final messages = <Message>[];

      for (final chatSnapshot in userChatsSnapshot.docs) {
        final chatData = chatSnapshot.data();
        final chatMessages = chatData['messages'] as List<dynamic>?;

        if (chatMessages != null && chatMessages.isNotEmpty) {
          final lastMessageData = chatMessages.last;
          final lastMessage = Message.fromJson(lastMessageData);
          messages.add(lastMessage);
        }
      }

      return messages;
    } catch (e) {
      throw ErrorFetchingChatsException();
    }
  }
}
