import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/models/message_model.dart';
import '../../../core/models/user_model.dart';
import '../../../core/services/firebase_service.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final FirebaseService _firebaseService;
  StreamSubscription<List<MessageModel>>? _messagesSubscription;

  ChatBloc(this._firebaseService) : super(ChatInitial()) {
    on<LoadMessages>(_onLoadMessages);
    on<SendMessage>(_onSendMessage);
    on<MarkMessageAsRead>(_onMarkMessageAsRead);
    on<ClearChat>(_onClearChat);
  }

  Future<void> _onLoadMessages(
    LoadMessages event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());

    await _messagesSubscription?.cancel();

    _messagesSubscription =
        _firebaseService.getMessages(event.senderId, event.receiverId).listen(
      (messages) {
        emit(ChatSuccess(
          messages: messages,
          receiver: event.receiver,
        ));
      },
      onError: (error) {
        emit(ChatFailure('Failed to load messages: $error'));
      },
    );
  }

  Future<void> _onSendMessage(
    SendMessage event,
    Emitter<ChatState> emit,
  ) async {
    try {
      final message = MessageModel(
        id: '', // Will be set by Firestore
        senderId: event.senderId,
        receiverId: event.receiverId,
        content: event.content,
        type: event.type,
        createdAt: DateTime.now(),
        imageUrl: event.imageUrl,
        drawingUrl: event.drawingUrl,
      );

      await _firebaseService.sendMessage(message);
    } catch (e) {
      emit(ChatFailure('Failed to send message: $e'));
    }
  }

  Future<void> _onMarkMessageAsRead(
    MarkMessageAsRead event,
    Emitter<ChatState> emit,
  ) async {
    try {
      final chatId = _getChatId(event.senderId, event.receiverId);
      await _firebaseService.markMessageAsRead(event.messageId, chatId);
    } catch (e) {
      // Don't emit failure for read status updates
    }
  }

  Future<void> _onClearChat(
    ClearChat event,
    Emitter<ChatState> emit,
  ) async {
    await _messagesSubscription?.cancel();
    emit(ChatInitial());
  }

  String _getChatId(String userId1, String userId2) {
    final sortedIds = [userId1, userId2]..sort();
    return '${sortedIds[0]}_${sortedIds[1]}';
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    return super.close();
  }
}
