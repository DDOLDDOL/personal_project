import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:personal_project/chat/chat.dart';

part 'chatting_room_create_state.dart';
part 'chatting_room_create_cubit.freezed.dart';

class ChattingRoomCreateCubit extends Cubit<ChattingRoomCreateState> {
  ChattingRoomCreateCubit(this._repository)
      : super(const ChattingRoomCreateState.initial());

  final ChatRepository _repository;

  Future<void> createChattingRoom(String withWhom) async {
    emit(const ChattingRoomCreateState.loading());

    try {
      final roomData = await _repository.createChattingRoom(withWhom);
      emit(ChattingRoomCreateState.success(roomData));
      print('채팅방이 생성되었습니다');
    } on Exception catch (error) {
      emit(
        ChattingRoomCreateState.error(
          '채팅방 생성 실패',
          error.toString().split('Exception: ').last,
        ),
      );
    }
  }
}
