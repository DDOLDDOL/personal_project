part of 'user_bloc.dart';

@freezed
class UserState with _$UserState {
  const factory UserState({
    User? user,
    bool? isFetching,
    String? errorMessage,
  }) = _UserState;

  const UserState._();

  bool get hasError => errorMessage != null;
}
