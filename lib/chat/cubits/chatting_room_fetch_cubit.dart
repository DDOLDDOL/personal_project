import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:personal_project/chat/chat.dart';

part 'chatting_room_fetch_state.dart';
part 'chatting_room_fetch_cubit.freezed.dart';

class ChattingRoomFetchCubit extends Cubit<ChattingRoomFetchState> {
  ChattingRoomFetchCubit(this._repository)
      : super(const ChattingRoomFetchState.initial());

  final ChatRepository _repository;

  Future<void> fetchChattingRooms() async {
    emit(const ChattingRoomFetchState.loading());

    try {
      final rooms = await _repository.fetchChattingRooms();
      emit(ChattingRoomFetchState.loaded(rooms));
    } on Exception catch (error) {
      emit(
        ChattingRoomFetchState.error(
          '채팅방 목록을 불러오는 데 실패했습니다',
          error.toString(),
        ),
      );
    }
  }
}
