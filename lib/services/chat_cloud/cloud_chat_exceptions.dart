class CloudChatException implements Exception {
  CloudChatException();
}

class ErrorCreatingChatException extends CloudChatException {}
class ErrorAddingMessageToChatException extends CloudChatException {}
class ErrorFetchingMessagesException extends CloudChatException {}
class ErrorFetchingChatsException extends CloudChatException {}