part of 'text_to_speech_bloc.dart';

@freezed
class TextToSpeechEvent with _$TextToSpeechEvent {
  const factory TextToSpeechEvent.readyRequested() = _ReadyRequested;
  const factory TextToSpeechEvent.playRequested(String text) = _PlayRequested;
  const factory TextToSpeechEvent.stopRequested() = _StopRequested;
}
