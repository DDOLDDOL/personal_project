part of 'message_update_cubit.dart';

@freezed
class MessageUpdateEvent with _$MessageUpdateEvent {
  const factory MessageUpdateEvent.sendRequested({
    required String chattingRoomId,
    required String text,
    required String sender,
  }) = _SendRequested;
  
  const factory MessageUpdateEvent.addRequested({
    required ChattingMessage message,
  }) = _AddRequested;
  
  const factory MessageUpdateEvent.updateRequested({
    required ChattingMessage message,
  }) = _UpdateRequested;
}
