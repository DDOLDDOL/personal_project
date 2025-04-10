part of 'user_search_cubit.dart';

@freezed
class UserSearchState with _$UserSearchState {
  const factory UserSearchState.initial() = _Initial;
  const factory UserSearchState.loading() = _Loading;
  const factory UserSearchState.loaded(User user) = _Loaded;
  const factory UserSearchState.error(String message, String reason) = _Error;
}
