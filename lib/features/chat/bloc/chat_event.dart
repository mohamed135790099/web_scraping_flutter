part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class LoadMessages extends ChatEvent {
  final String senderId;
  final String receiverId;
  final UserModel receiver;

  const LoadMessages({
    required this.senderId,
    required this.receiverId,
    required this.receiver,
  });

  @override
  List<Object?> get props => [senderId, receiverId, receiver];
}

class SendMessage extends ChatEvent {
  final String senderId;
  final String receiverId;
  final String content;
  final MessageType type;
  final String? imageUrl;
  final String? drawingUrl;

  const SendMessage({
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.type,
    this.imageUrl,
    this.drawingUrl,
  });

  @override
  List<Object?> get props =>
      [senderId, receiverId, content, type, imageUrl, drawingUrl];
}

class MarkMessageAsRead extends ChatEvent {
  final String messageId;
  final String senderId;
  final String receiverId;

  const MarkMessageAsRead({
    required this.messageId,
    required this.senderId,
    required this.receiverId,
  });

  @override
  List<Object?> get props => [messageId, senderId, receiverId];
}

class ClearChat extends ChatEvent {}
