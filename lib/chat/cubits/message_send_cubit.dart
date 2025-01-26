import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:personal_project/chat/chat.dart';

part 'message_send_state.dart';
part 'message_send_cubit.freezed.dart';

class MessageSendCubit extends Cubit<MessageSendState> {
  MessageSendCubit(this._repository) : super(const MessageSendState.initial());

  final ChatRepository _repository;

  Future<void> sendMessage(
    String chattingRoomId,
    String text,
    String sender,
  ) async {
    emit(const MessageSendState.loading());

    await Future.delayed(Duration(seconds: 2));

    try {
      await _repository.sendMessage(chattingRoomId, text, sender);
      emit(const MessageSendState.success());
    } on Exception catch (error) {
      emit(MessageSendState.error('메시지를 보내지 못했습니다', error.toString()));
    }
  }

  // void _onSendRequested(
  //   _SendRequested event,
  //   Emitter<List<ChattingMessage>> emit,
  // ) {
  //   _repository.sendMessage(event.chattingRoomId, event.text, event.sender);
  // }

  // void _onAddRequested(
  //   _AddRequested event,
  //   Emitter<List<ChattingMessage>> emit,
  // ) {
  //   print('--! ${event.message.text}');
  //   print(event.message.dateTime);

  //   emit([...state, event.message]);
  // }

  // void _onUpdateRequested(
  //   _UpdateRequested event,
  //   Emitter<List<ChattingMessage>> emit,
  // ) {
  //   final updatedMessageIndex =
  //       state.indexWhere((message) => message.id == event.message.id);

  //   if (updatedMessageIndex == -1) return;

  //   emit(
  //     [
  //       ...state.sublist(0, updatedMessageIndex),
  //       event.message,
  //       ...state.sublist(updatedMessageIndex + 1),
  //     ],
  //   );
  // }

  // void _listenMessage((ChattingMessage message, bool isNewMessage) result) {
  //   final (message, isNewMessage) = result;

  //   if (isNewMessage) {
  //     // 새 메시지일 경우
  //     return add(MessageSendEvent.addRequested(message: message));
  //   }

  //   // 인자로 전달된 메시지가 이미 state에 포함되어 있는 경우
  //   add(MessageSendEvent.updateRequested(message: message));
  // }

  // @override
  // Future<void> close() {
  //   _messageSubscription.cancel();
  //   return super.close();
  // }
}
