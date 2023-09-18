import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_chating/utils/constants.dart';

import '../../../model/model.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());
  StreamSubscription<List<Message>>? _messageSubscription;
  List<Message> _messages = [];

  late final String _roomId;
  late final String _myUserId;

  void setMessagesListener(String roomId) {
    _roomId = roomId;
    _myUserId = supabase.auth.currentUser!.id;
    _messageSubscription = supabase
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('room_id', roomId)
        .order('created_at')
        .map<List<Message>>(
          (data) => data
              .map<Message>(
                  (row) => Message.fromMap(map: row, myUserId: _myUserId))
              .toList(),
        )
        .listen(
          (messages) {
            _messages = messages;
            if (_messages.isEmpty) {
              emit(ChatEmpty());
            } else {
              emit(ChatLoaded(_messages));
            }
          },
        );
  }

  Future<void> sendMessage(String text) async {
    /// Add message to present to the user right away
    final message = Message(
      id: 'new',
      roomId: _roomId,
      profileId: _myUserId,
      content: text,
      createdAt: DateTime.now(),
      isMine: true,
    );

    _messages.insert(0, message);
    emit(ChatLoaded(_messages));
    try {
      await supabase.from('messages').insert(message.toMap());
    } catch (_) {
      emit(ChatError('Error submitting message.'));
      _messages.removeWhere((message) => message.id == 'new');
      emit(ChatLoaded(_messages));
    }
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    return super.close();
  }
}
