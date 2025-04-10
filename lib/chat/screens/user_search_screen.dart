import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_project/auth/auth.dart';
import 'package:personal_project/chat/chat.dart';
import 'package:personal_project/common/common.dart';

class UserSearchScreen extends StatelessWidget {
  const UserSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UserSearchCubit(context.read<ChatRepository>()),
        ),
        BlocProvider(
          create: (context) {
            return ChattingRoomCreateCubit(context.read<ChatRepository>());
          },
        ),
      ],
      child: const _UserSearchView(),
    );
  }
}

class _UserSearchView extends StatelessWidget {
  const _UserSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChattingRoomCreateCubit, ChattingRoomCreateState>(
      listener: (context, state) {
        state.whenOrNull(
          success: (roomData) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => ChattingScreen(roomData: roomData),
              ),
            );
          },
        );
      },
      child: Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: BlocBuilder<UserSearchCubit, UserSearchState>(
              builder: (_, state) {
                return state.maybeWhen(
                  orElse: _SearchForm.new,
                  loaded: (user) => _SearchResultView(user: user),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchForm extends StatefulWidget {
  const _SearchForm({super.key});

  @override
  State<_SearchForm> createState() => _SearchFormState();
}

class _SearchFormState extends State<_SearchForm> {
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextInputField(
          textInputAction: TextInputAction.go,
          onFieldSubmitted: context.read<UserSearchCubit>().searchUserByEmail,
        ),
        const SizedBox(height: 20),
        Expanded(
          child: BlocBuilder<UserSearchCubit, UserSearchState>(
            builder: (_, state) {
              return state.maybeWhen(
                orElse: SizedBox.shrink,
                error: (message, reason) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 60),
                    child: Center(child: Text(reason)),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SearchResultView extends StatelessWidget {
  const _SearchResultView({
    super.key,
    required this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserSearchCubit, UserSearchState>(
      builder: (context, state) {
        return state.maybeWhen(
          orElse: SizedBox.shrink,
          loaded: (user) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: context.read<UserSearchCubit>().clearResult,
                    child: const Icon(Icons.close_outlined),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(height: 20),
                Text(user.email),
                const Spacer(),
                BlocBuilder<ChattingRoomCreateCubit, ChattingRoomCreateState>(
                  builder: (context, state) {
                    return SubmitButton(
                      loadingWhen:
                          state.whenOrNull(loading: () => true) ?? false,
                      onPressed: () {
                        final roomData = context
                            .read<ChattingRoomFetchBloc>()
                            .state
                            .whenOrNull(
                          loaded: (rooms) {
                            return rooms.where(
                              (room) {
                                return room.participants.length == 2 &&
                                    room.participants.contains(user.email);
                              },
                            ).firstOrNull;
                          },
                        );

                        // 검색한 유저와의 채팅방이 이미 존재하는 경우에는 그 방으로 진입
                        if (roomData != null) {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) {
                                return ChattingScreen(roomData: roomData);
                              },
                            ),
                          );

                          return;
                        }

                        // 검색한 유저와의 채팅방이 존재하지 않는 경우에는 방을 생성
                        context
                            .read<ChattingRoomCreateCubit>()
                            .createChattingRoom(user.email);
                      },
                      child: const Text('메시지 보내기'),
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
