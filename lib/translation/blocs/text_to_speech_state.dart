part of 'text_to_speech_bloc.dart';

@freezed
class TextToSpeechState with _$TextToSpeechState {
  const factory TextToSpeechState.initial() = _Initial;
  const factory TextToSpeechState.ready() = _Ready;
  const factory TextToSpeechState.playing(String text) = _Playing;
  const factory TextToSpeechState.stopped() = _Stopped;
}
