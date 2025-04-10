import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:personal_project/chat/chat.dart';

part 'chatting_room_fetch_event.dart';
part 'chatting_room_fetch_state.dart';
part 'chatting_room_fetch_bloc.freezed.dart';

class ChattingRoomFetchBloc
    extends Bloc<ChattingRoomFetchEvent, ChattingRoomFetchState> {
  ChattingRoomFetchBloc(this._repository)
      : super(const ChattingRoomFetchState.loading()) {
    on<_UpdateRequested>(_onChattingRoomsUpdateRequested);
    _roomSubscription = _repository.roomStream.listen(
      (rooms) => add(ChattingRoomFetchEvent.updateRequested(rooms)),
    );
  }

  final ChatRepository _repository;
  late final StreamSubscription _roomSubscription;

  Future<void> startListenChattingRooms() async {
    emit(const ChattingRoomFetchState.loading());

    try {
      _repository.startListenChattingRooms();
      emit(ChattingRoomFetchState.loaded());
    } on Exception catch (error) {
      emit(
        ChattingRoomFetchState.error(
          '채팅방 목록을 불러오는 데 실패했습니다',
          error.toString(),
        ),
      );
    }
  }

  void _onChattingRoomsUpdateRequested(
    _UpdateRequested event,
    Emitter<ChattingRoomFetchState> emit,
  ) async {
    emit(ChattingRoomFetchState.loaded(event.rooms));
  }

  @override
  Future<void> close() async {
    _roomSubscription.cancel();
    return super.close();
  }
}
