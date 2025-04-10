import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:personal_project/auth/auth.dart';
import 'package:personal_project/chat/chat.dart';
import 'package:personal_project/common/hives/auth_hive.dart';

class ChatRepository {
  ChatRepository()
      : _database = FirebaseFirestore.instance,
        _roomController = StreamController.broadcast();
  // _messageStreamController = StreamController.broadcast();

  final FirebaseFirestore _database;
  final StreamController<List<ChattingRoomData>> _roomController;
  // final StreamController<ChattingMessage> _messageStreamController;

  // 업데이트 되는 메시지들을 전달
  // Stream<ChattingMessage> get messageStream => _messageStreamController.stream;

  // 업데이트 되는 방 정보들을 전달
  Stream<List<ChattingRoomData>> get roomStream => _roomController.stream;

  Future<User> searchUserByEmail(String email) async {
    if (email == AuthHive.instance.email) throw Exception('검색 결과가 없습니다');

    final result = await _database
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    final user = result.docs
        .map((doc) => doc.data()..addAll({'id': doc.id}))
        .map(User.fromJson)
        .firstOrNull;

    if (user == null) throw Exception('검색 결과가 없습니다');
    return user;
  }

  void startListenChattingRooms() {
    _database
        .collection('rooms')
        .where('participants', arrayContains: AuthHive.instance.email)
        .snapshots(
            // source: ListenSource.cache,
            )
        .listen(
      (data) {
        final result = data.docs.map(
          (doc) => doc.data()..addAll({'id': doc.id}),
        );

        _roomController.sink.add(
          result.map(ChattingRoomData.fromJson).toList(),
        );
      },
    );
  }

  // Future<List<ChattingRoomData>> fetchChattingRooms() async {
  //   // TODO: 내가 포함되어 있는 대화방만 추가
  //   // final result = await _database.collection('rooms').where('field', ).get();
  //   final result = await _database.collection('rooms').get();

  //   return result.docs
  //       .map((doc) {
  //         print('data from cache? ${doc.metadata.isFromCache}');

  //         return doc.data()..addAll({'id': doc.id});
  //       })
  //       .map(ChattingRoomData.fromJson)
  //       .toList();
  // }

  Future<ChattingRoomData> createChattingRoom(String withWhom) async {
    try {
      final me = AuthHive.instance.email;

      if (me == null) {
        throw Exception('계정 정보가 만료되었습니다. 다시 로그인 해주세요.');
      }

      // if ((await _database.collection('rooms').where('participants', arrayContains: [me, withWhom]).get()).)

      final result = await _database.collection('rooms').add(
        {
          'participants': [me, withWhom],
        },
      );

      final roomDataMap = (await result.get()).data();
      roomDataMap?['id'] = result.id;
      roomDataMap?['participant'] = result.id;

      if (roomDataMap == null) {
        throw Exception('생성된 채팅방의 정보를 불러올 수 없습니다.');
      }

      return ChattingRoomData.fromJson(roomDataMap);
    } on Exception {
      rethrow;
    }
  }

  Future<List<ChattingMessage>> fetchMessages(String chattingRoomId) async {
    return [];
    // final result = await _database
    //     .collection('rooms')
    //     .doc(chattingRoomId)
    //     .collection('messages')
    //     .get();

    // return result.docs
    //     .map((doc) => doc.data()..addAll({'id': doc.id}))
    //     .map(ChattingMessage.fromJson)
    //     .toList();
  }

  Future<void> sendMessage(
    String chattingRoomId,
    String text,
    String sender,
  ) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();

    _database
        .collection('rooms')
        .doc(chattingRoomId)
        .collection('messages')
        .doc(id)
        .set(
      {
        'text': text,
        'sender': sender,
        'createdAt': Timestamp.fromDate(DateTime.now()),
        'readers': [sender], // 읽은 사람에 본인 추가할지 검토
      },
    ).then(
      (_) {
        // 메시지 전송이 성공했을 때
      },
      // onError: throw
    );

    // late final Response response;

    // final mockSuccessResponse = Response(
    //   data: {
    //     'message_id': id,
    //   },
    //   statusCode: 200,
    //   requestOptions: RequestOptions(),
    // );

    // final mockFailedResponse = Response(
    //   data: {
    //     'message_id': id,
    //     'message': '메시지를 보내는 데에 실패했습니다',
    //     'reason': '',
    //   },
    //   statusCode: 401,
    //   requestOptions: RequestOptions(),
    // );

    // await Future.delayed(Duration(seconds: 1));

    // response = content.toLowerCase().contains('error')
    //     ? mockFailedResponse
    //     : mockSuccessResponse;
    // if (response.hasException) throw response.exception!;
  }
}
