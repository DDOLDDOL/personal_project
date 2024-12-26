part of 'fetch_request_cubit.dart';

@freezed
class FetchRequestState<T> with _$FetchRequestState {
  const factory FetchRequestState.initial() = _Initial;
  const factory FetchRequestState.loading() = _Loading;
  const factory FetchRequestState.loaded(T result) = _Loaded;
  const factory FetchRequestState.error(String message, String reason) = _Error;
}
