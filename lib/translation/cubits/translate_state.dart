part of 'translate_cubit.dart';

@freezed
class TranslateState with _$TranslateState {
  const factory TranslateState.initial() = _Initial;
  const factory TranslateState.loading() = _Loading;
  const factory TranslateState.done(String result) = _Done;
  const factory TranslateState.error(String message, String reason) = _Error;
}
