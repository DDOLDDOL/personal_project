part of 'message_update_cubit.dart';

@freezed
class MessageUpdateState with _$MessageUpdateState {
  const factory MessageUpdateState({
    @Default([]) List<ChattingMessage> newMessages,
  }) = _MessageUpdateState;
}