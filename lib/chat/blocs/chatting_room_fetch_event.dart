part of 'chatting_room_fetch_bloc.dart';

@freezed
class ChattingRoomFetchEvent with _$ChattingRoomFetchEvent {
  const factory ChattingRoomFetchEvent.updateRequested(
    List<ChattingRoomData> rooms,
  ) = _UpdateRequested;
}
