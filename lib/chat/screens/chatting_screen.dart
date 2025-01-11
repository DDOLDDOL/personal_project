import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_project/chat/chat.dart';

class ChattingScreen extends StatelessWidget {
  const ChattingScreen({
    super.key,
    required this.roomData,
  });

  final ChattingRoomData roomData;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          // TODO: 채팅 모듈 로컬 테스트 완료 아래에 후에 주석친 context.read<ChatRepository>()로 교환합니다
          create: (context) => MessageFetchCubit(context.read<ChatRepository>())
            ..fetchMessages(roomData.id),
          // create: (context) {
          //   return MessageFetchCubit(ChatRepository(context.read<ApiClient>()))
          // ..fetchMessages(chattingRoomData.id);
          // },
        ),
        BlocProvider(
          // TODO: 채팅 모듈 로컬 테스트 완료 아래에 후에 주석친 context.read<ChatRepository>()로 교환합니다
          create: (context) =>
              MessageUpdateBloc(context.read<ChatRepository>()),
          // create: (context) {
          // return MessageUpdateBloc(ChatRepository(context.read<ApiClient>()));
          // },
        ),
      ],
      child: _ChattingView(roomData: roomData),
    );
  }
}

class _ChattingView extends StatefulWidget {
  const _ChattingView({
    super.key,
    required this.roomData,
  });

  final ChattingRoomData roomData;

  @override
  State<_ChattingView> createState() => _ChattingViewState();
}

class _ChattingViewState extends State<_ChattingView> {
  late final ScrollController _scrollController;
  late bool _isFirstFetch;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _isFirstFetch = true;
  }

  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                controller: _scrollController,
                padding: const EdgeInsets.all(20),
                physics: const ClampingScrollPhysics(),
                children: [
                  _PreviousMessageListView(
                    me: widget.roomData.participants[0],
                    onMessageFetched: (_) async {
                      return _initScrollToEnd();
                    },
                  ),
                  _CurrentMessageListView(
                    me: widget.roomData.participants[0],
                    onMessageUpdated: (_) {
                      if (_scrollController.hasClients) {
                        final position =
                            _scrollController.position.maxScrollExtent;
                        _scrollController.animateTo(
                          position,
                          duration: const Duration(milliseconds: 100),
                          curve: Curves.ease,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            MessageInputForm(
              onSend: (message) {
                context.read<MessageSendCubit>().sendMessage(
                      widget.roomData.id,
                      message,
                      widget.roomData.participants[0],
                    );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _initScrollToEnd() async {
    if (_isFirstFetch) {
      // Future.delayed(Duration(milliseconds: 500));

      _scrollController.jumpTo(
        _scrollController.position.maxScrollExtent,
      );

      print('ppll: ${_scrollController.position.maxScrollExtent}');
      _isFirstFetch = false;
      // return Future.microtask(
      //   () {
      //     _scrollController.jumpTo(
      //       _scrollController.position.maxScrollExtent,
      //     );

      //     print('ppll: ${_scrollController.position.maxScrollExtent}');
      //     _isFirstFetch = false;
      //   },
      // );
    }
  }
}

class _CurrentMessageListView extends StatelessWidget {
  const _CurrentMessageListView({
    super.key,
    required this.me,
    this.onMessageUpdated,
  });

  // TODO: 토큰 인증이 붙고 나면 이 인자 역시 삭제합니다
  final String me;
  final void Function(List<ChattingMessage>)? onMessageUpdated;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MessageSendCubit, MessageSendState>(
      listener: (_, state) {
        // onMessageUpdated.call(messages);
      },
      builder: (_, state) {
        return ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: messages.length,
          itemBuilder: (_, index) {
            return MessageBalloon(
              message: messages[index],
              isMine: messages[index].sender == me,
            );
          },
          separatorBuilder: (_, __) => const SizedBox(height: 8),
        );
      },
    );
  }
}

class _PreviousMessageListView extends StatelessWidget {
  const _PreviousMessageListView({
    super.key,
    required this.me,
    required this.onMessageFetched,
  });

  // TODO: 토큰 인증이 붙고 나면 이 인자 역시 삭제합니다
  final String me;
  final void Function(List<ChattingMessage>)? onMessageFetched;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MessageFetchCubit, MessageFetchState>(
      listener: (_, state) {
        state.whenOrNull(loaded: onMessageFetched?.call);
      },
      builder: (_, state) {
        return state.maybeWhen(
          orElse: SizedBox.shrink,
          loaded: (messages) {
            return ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: messages.length,
              itemBuilder: (_, index) {
                return MessageBalloon(
                  message: messages[index],
                  isMine: messages[index].sender == me,
                );
              },
              separatorBuilder: (_, __) => const SizedBox(height: 8),
            );
          },
        );
      },
    );
  }
}
