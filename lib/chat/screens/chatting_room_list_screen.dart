import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_project/chat/chat.dart';

class ChattingRoomListScreen extends StatelessWidget {
  const ChattingRoomListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return ChattingRoomFetchBloc(context.read<ChatRepository>())
          ..fetchChattingRooms();
      },
      child: const _ChattingRoomListView(),
    );
  }
}

class _ChattingRoomListView extends StatelessWidget {
  const _ChattingRoomListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('채팅방'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<ChattingRoomFetchBloc>(),
                    child: const UserSearchScreen(),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<ChattingRoomFetchBloc, ChattingRoomFetchState>(
          builder: (context, state) {
            return state.maybeWhen(
              orElse: SizedBox.shrink,
              loading: () => const Center(child: CircularProgressIndicator()),
              loaded: (rooms) {
                return ListView(
                  children: rooms
                      .map((room) => ChattingRoomListTile(roomData: room))
                      .toList(),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
