part of 'chatting_room_fetch_cubit.dart';

@freezed
class ChattingRoomFetchState with _$ChattingRoomFetchState {
  const factory ChattingRoomFetchState.initial() = _Initial;
  const factory ChattingRoomFetchState.loading() = _Loading;
  const factory ChattingRoomFetchState.loaded(
    List<ChattingRoomData> rooms,
  ) = _Loaded;
  const factory ChattingRoomFetchState.error(
    String message,
    String reason,
  ) = _Error;
}
