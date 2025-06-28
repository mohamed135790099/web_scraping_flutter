part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatSuccess extends ChatState {
  final List<MessageModel> messages;
  final UserModel receiver;

  const ChatSuccess({
    required this.messages,
    required this.receiver,
  });

  @override
  List<Object?> get props => [messages, receiver];
}

class ChatFailure extends ChatState {
  final String message;

  const ChatFailure(this.message);

  @override
  List<Object?> get props => [message];
}
