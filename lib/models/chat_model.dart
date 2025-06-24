class ChatModel {
  final String? chatId;
  final String? message;
  final bool? isUser;
  final bool? isError;
  final bool? isImageUploaded;
  final String? filePath;

  ChatModel({
    required this.chatId,
    required this.message,
    required this.isUser,
    this.isError,
    this.isImageUploaded,
    this.filePath,
  });
}
