import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'fetch_request_state.dart';
part 'fetch_request_cubit.freezed.dart';

class FetchRequestCubit<T> extends Cubit<FetchRequestState<T>> {
  FetchRequestCubit() : super(const FetchRequestState.initial());

  Future<void> fetch(
    Future<T> Function() request, {
    String? errorMessage,
  }) async {
    emit(const FetchRequestState.loading());

    try {
      final result = await request();
      emit(FetchRequestState.loaded(result));
    } on Exception catch (error) {
      emit(
        FetchRequestState.error(
          errorMessage ?? '서버와의 오류가 발생했습니다',
          error.toString(),
        ),
      );
    }
  }
}
