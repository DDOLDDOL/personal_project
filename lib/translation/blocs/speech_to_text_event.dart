part of 'speech_to_text_bloc.dart';

@freezed
class SpeechToTextEvent with _$SpeechToTextEvent {
  const factory SpeechToTextEvent.initRequired() = _InitRequired;
  const factory SpeechToTextEvent.listenRequired() = _ListenRequired;
  const factory SpeechToTextEvent.textGenerationRequired(
    String generated,
  ) = _TextGenerationRequired;
}
