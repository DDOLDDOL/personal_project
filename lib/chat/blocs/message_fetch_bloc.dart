import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:personal_project/chat/chat.dart';

part 'message_fetch_event.dart';
part 'message_fetch_state.dart';
part 'message_fetch_bloc.freezed.dart';

class MessageFetchBloc extends Bloc<MessageFetchEvent, MessageFetchState> {
  MessageFetchBloc(this._repository) : super(const MessageFetchState()) {
    on<_UpdateRequested>(_onUpdateRequested);
    on<_FetchRequested>(_onFetchRequested);

    _messageSubscription = _repository.messageStream.listen(
      (message) => add(MessageFetchEvent.updateRequested(message)),
    );
  }

  final ChatRepository _repository;
  late final StreamSubscription<ChattingMessage> _messageSubscription;

  Future<void> _onFetchRequested(
    _FetchRequested event,
    Emitter<MessageFetchState> emit,
  ) async {
    try {
      final messages = await _repository.fetchMessages(event.chattingRoomId);
      emit(state.copyWith(isLoading: false, messages: messages));
    } on Exception catch (error) {
      emit(state.copyWith(isLoading: false, errorMessage: error.toString()));
    }
  }

  Future<void> _onUpdateRequested(
    _UpdateRequested event,
    Emitter<MessageFetchState> emit,
  ) async {
    emit(
      state.copyWith(
        isLoading: false,
        messages: [...state.messages, event.message],
      ),
    );
  }

  @override
  Future<void> close() async {
    _messageSubscription.cancel();
    return super.close();
  }
}
