import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:personal_project/auth/auth.dart';

part 'user_event.dart';
part 'user_state.dart';
part 'user_bloc.freezed.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  /// 앱 전반에서 [User]의 상태를 관리합니다
  ///
  /// 앱의 Auth 분기는 [UserAuthState]가 아닌 [UserState]에 의해 처리합니다
  UserBloc(this._repository) : super(const UserState()) {
    _userSubscription = _repository
        .watchUser()
        .listen((user) => add(UserEvent.userUpdateRequested(user)));

    on<_UserUpdateRequested>(_onUserUpdateRequested);
  }

  factory UserBloc.create(BuildContext context) => UserBloc(
        context.read<AuthRepository>(),
      );

  factory UserBloc.of(BuildContext context) =>
      context.read<UserBloc?>() ?? UserBloc.create(context);

  final AuthRepository _repository;
  late final StreamSubscription<User?> _userSubscription;

  Future<void> _onUserUpdateRequested(
    _UserUpdateRequested event,
    Emitter<UserState> emit,
  ) async {
    if (event.user == null) return emit(const UserState());
    emit(UserState(user: event.user!));
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
