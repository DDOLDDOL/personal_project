import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:personal_project/translation/translation.dart';

part 'translate_state.dart';
part 'translate_cubit.freezed.dart';

class TranslateCubit extends Cubit<TranslateState> {
  TranslateCubit(this._repository) : super(const TranslateState.initial());

  final TranslationRepository _repository;

  Future<void> translate(List<String> texts, String endLocale) async {
    emit(const TranslateState.loading());

    try {
      final result = await _repository.translate(texts, endLocale);
      emit(TranslateState.done(result));
    } on Exception catch (error) {
      emit(TranslateState.error('번역에 실패했습니다', error.toString()));
    }
  }
}
