part of 'message_fetch_cubit.dart';

@freezed
class MessageFetchState with _$MessageFetchState {
  const factory MessageFetchState.initial() = _Initial;
  const factory MessageFetchState.loading() = _Loading;
  const factory MessageFetchState.loaded(
    List<ChattingMessage> messages,
  ) = _Loaded;
  const factory MessageFetchState.error(
    String message,
    String reason,
  ) = _Error;
}
