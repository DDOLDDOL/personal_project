import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:personal_project/auth/auth.dart';
import 'package:personal_project/common/common.dart';

part 'auth_state.dart';
part 'auth_cubit.freezed.dart';

class AuthCubit extends Cubit<AuthState> {
  /// 로그인의 성공/실패 상태만 관리하는 Cubit입니다
  /// 로그인 요청에 대한 상태 관리를 위해 UserBloc과 분리했습니다
  AuthCubit(this._repository) : super(const AuthState.initial());

  final AuthRepository _repository;

  Future<void> requestOAuthLogin(OAuthPlatform platform) async {
    emit(AuthState.loading(platform));

    try {
      await _repository.requestOAuthLogin(platform);
      emit(const AuthState.success());
    } on Exception catch (error) {
      emit(
        AuthState.error(
          '로그인 요청에 실패했습니다',
          error.toString().split('Exception: ').last,
        ),
      );
    }
  }

  Future<void> logout() {
    return _repository.logout(AuthHive.instance.oAuthProvider!);
  }
}
