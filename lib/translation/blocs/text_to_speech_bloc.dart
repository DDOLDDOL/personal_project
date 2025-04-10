import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:personal_project/translation/repository/translation_repository.dart';

part 'text_to_speech_event.dart';
part 'text_to_speech_state.dart';
part 'text_to_speech_bloc.freezed.dart';

class TextToSpeechBloc extends Bloc<TextToSpeechEvent, TextToSpeechState> {
  TextToSpeechBloc(this._repository) : super(const TextToSpeechState.initial()) {
    on<_ReadyRequested>(_onReadyRequested);
    on<_PlayRequested>(_onPlayRequested);
    on<_StopRequested>(_onStopRequested);
  }

  final TranslationRepository _repository;

  // Initialize TextToSpeech
  Future<void> _onReadyRequested(
    _ReadyRequested event,
    Emitter<TextToSpeechState> emit,
  ) async {
    try {
      await _repository.initTextToSpeech();
      emit(const TextToSpeechState.ready());
    // ignore: empty_catches
    } on Exception {}
  }

  // TextToSpeech 음성 읽기 시작
  Future<void> _onPlayRequested(
    _PlayRequested event,
    Emitter<TextToSpeechState> emit,
  ) async {
    
  }

  // TextToSpeech 음성 읽기 중지
  Future<void> _onStopRequested(
    _StopRequested event,
    Emitter<TextToSpeechState> emit,
  ) async {
    
  }
}
