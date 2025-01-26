part of 'message_send_cubit.dart';

@freezed
class MessageSendState with _$MessageSendState {
  const factory MessageSendState.initial() = _Initial;
  const factory MessageSendState.loading() = _Loading;
  const factory MessageSendState.success() = _Success;
  const factory MessageSendState.error(
    String message,
    String reason,
  ) = _Error;
}
