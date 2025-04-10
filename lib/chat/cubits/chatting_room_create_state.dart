part of 'chatting_room_create_cubit.dart';

@freezed
class ChattingRoomCreateState with _$ChattingRoomCreateState {
  const factory ChattingRoomCreateState.initial() = _Initial;
  const factory ChattingRoomCreateState.loading() = _Loading;
  const factory ChattingRoomCreateState.success(
    ChattingRoomData roomData,
  ) = _Success;
  const factory ChattingRoomCreateState.error(
    String message,
    String reason,
  ) = _Error;
}
