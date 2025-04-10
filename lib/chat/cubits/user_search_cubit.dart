import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:personal_project/auth/auth.dart';
import 'package:personal_project/chat/chat.dart';

part 'user_search_state.dart';
part 'user_search_cubit.freezed.dart';

class UserSearchCubit extends Cubit<UserSearchState> {
  UserSearchCubit(this._repository) : super(const UserSearchState.initial());

  final ChatRepository _repository;

  Future<void> searchUserByEmail(String email) async {
    try {
      final user = await _repository.searchUserByEmail(email);
      emit(UserSearchState.loaded(user));
    } on Exception catch (error) {
      emit(
        UserSearchState.error(
          '유저 검색 실패',
          error.toString().split('Exception: ').last,
        ),
      );
    }
  }

  void clearResult() => emit(const UserSearchState.initial());
}
