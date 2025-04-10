part of 'speech_to_text_bloc.dart';

@freezed
class SpeechToTextState with _$SpeechToTextState {
  const factory SpeechToTextState.initial() = _Initial;
  const factory SpeechToTextState.ready() = _Ready;
  const factory SpeechToTextState.listening() = _Listening;
  const factory SpeechToTextState.done(String result) = _Done;
  const factory SpeechToTextState.error(String message, String reason) = _Error;
}
