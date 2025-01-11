import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:personal_project/chat/chat.dart';

part 'message_update_event.dart';
part 'message_update_state.dart';
part 'message_update_cubit.freezed.dart';

class MessageUpdateBloc
    extends Bloc<MessageUpdateEvent, List<ChattingMessage>> {
  MessageUpdateBloc(this._repository) : super([]) {
    on<_SendRequested>(_onSendRequested);
    on<_AddRequested>(_onAddRequested);
    on<_UpdateRequested>(_onUpdateRequested);

    _messageSubscription = _repository.messageStream.listen(_listenMessage);
  }

  final ChatRepository _repository;
  late final StreamSubscription<(ChattingMessage, bool)> _messageSubscription;

  void _onSendRequested(
    _SendRequested event,
    Emitter<List<ChattingMessage>> emit,
  ) {
    _repository.sendMessage(event.chattingRoomId, event.text, event.sender);
  }

  void _onAddRequested(
    _AddRequested event,
    Emitter<List<ChattingMessage>> emit,
  ) {
    print('--! ${event.message.text}');
    print(event.message.dateTime);

    emit([...state, event.message]);
  }

  void _onUpdateRequested(
    _UpdateRequested event,
    Emitter<List<ChattingMessage>> emit,
  ) {
    final updatedMessageIndex =
        state.indexWhere((message) => message.id == event.message.id);

    if (updatedMessageIndex == -1) return;

    emit(
      [
        ...state.sublist(0, updatedMessageIndex),
        event.message,
        ...state.sublist(updatedMessageIndex + 1),
      ],
    );
  }

  void _listenMessage((ChattingMessage message, bool isNewMessage) result) {
    final (message, isNewMessage) = result;

    if (isNewMessage) {
      // 새 메시지일 경우
      return add(MessageUpdateEvent.addRequested(message: message));
    }

    // 인자로 전달된 메시지가 이미 state에 포함되어 있는 경우
    add(MessageUpdateEvent.updateRequested(message: message));
  }

  @override
  Future<void> close() {
    _messageSubscription.cancel();
    return super.close();
  }
}
