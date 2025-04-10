import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:personal_project/translation/translation.dart';

part 'speech_to_text_event.dart';
part 'speech_to_text_state.dart';
part 'speech_to_text_bloc.freezed.dart';

class SpeechToTextBloc extends Bloc<SpeechToTextEvent, SpeechToTextState> {
  SpeechToTextBloc(this._repository)
      : super(const SpeechToTextState.initial()) {
    on<_InitRequired>(_onReadyRequired);
    on<_ListenRequired>(_onListenRequired);
    on<_TextGenerationRequired>(_onTextGenerationRequired);

    _speechToTextSubscription = _repository.speechToTextStream.listen(
      (sttResult) => add(SpeechToTextEvent.textGenerationRequired(sttResult)),
    );
  }

  final TranslationRepository _repository;
  late final StreamSubscription _speechToTextSubscription;

  Future<void> _onReadyRequired(
    _InitRequired event,
    Emitter<SpeechToTextState> emit,
  ) async {
    try {
      await _repository.initSpeechToText();
      emit(const SpeechToTextState.ready());
      // ignore: empty_catches
    } on Exception {}
  }

  Future<void> _onListenRequired(
    _ListenRequired event,
    Emitter<SpeechToTextState> emit,
  ) async {
    try {
      _repository.startSpeechToText();
      emit(const SpeechToTextState.ready());
      // ignore: empty_catches
    } on Exception {}
  }

  void _onTextGenerationRequired(
    _TextGenerationRequired event,
    Emitter<SpeechToTextState> emit,
  ) async {
    emit(SpeechToTextState.done(event.generated));
  }

  @override
  Future<void> close() async {
    _speechToTextSubscription.cancel();
    return super.close();
  }
}
