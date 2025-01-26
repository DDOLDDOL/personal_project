part of 'auth_cubit.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading(OAuthPlatform platform) = _Loading;
  const factory AuthState.success() = _Success;
  const factory AuthState.error(String message, String reason) = _Error;
}
