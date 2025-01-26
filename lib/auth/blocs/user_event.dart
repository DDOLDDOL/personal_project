part of 'user_bloc.dart';

@freezed
class UserEvent with _$UserEvent {
  const factory UserEvent.loginRequested(
    OAuthPlatform platform,
  ) = _LoginRequested;
  const factory UserEvent.logoutRequested() = _LogoutRequested;
  const factory UserEvent.userUpdateRequested(
    User? user,
  ) = _UserUpdateRequested;
}
