import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:personal_project/chat/chat.dart';

part 'message_fetch_state.dart';
part 'message_fetch_cubit.freezed.dart';

class MessageFetchCubit extends Cubit<MessageFetchState> {
  MessageFetchCubit(this._repository)
      : super(const MessageFetchState.initial());

  final ChatRepository _repository;

  Future<void> fetchMessages(String chattingRoomId) async {
    emit(const MessageFetchState.loading());

    try {
      final messages = await _repository.fetchMessages(chattingRoomId);
      emit(MessageFetchState.loaded(messages));
    } on Exception catch (error) {}
  }
}
