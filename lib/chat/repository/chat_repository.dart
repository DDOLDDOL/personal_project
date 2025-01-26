import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:personal_project/chat/chat.dart';

class ChatRepository {
  ChatRepository()
      : _database = FirebaseFirestore.instance,
        _messageStreamController = StreamController.broadcast() {
    _database
        .collection('rooms')
        .doc('room1')
        .collection('messages')
        .snapshots(source: ListenSource.cache)
        .listen(
      (data) {
        final result = data.docChanges.map(
          (changed) => changed.doc.data()!..addAll({'id': changed.doc.id}),
        );

        for (final data in result) {
          print('------------------- ${data.toString()}');
          _messageStreamController.sink.add(ChattingMessage.fromJson(data));
        }
      },
    );
  }

  final FirebaseFirestore _database;
  final StreamController<ChattingMessage> _messageStreamController;

  // 업데이트 되는 메시지들을 전달
  Stream<ChattingMessage> get messageStream => _messageStreamController.stream;

  Future<List<ChattingRoomData>> fetchChattingRooms() async {
    // TODO: 내가 포함되어 있는 대화방만 추가
    // final result = await _database.collection('rooms').where('field', ).get();
    final result = await _database.collection('rooms').get();

    return result.docs
        .map((doc) => doc.data()..addAll({'id': doc.id}))
        .map(ChattingRoomData.fromJson)
        .toList();
  }

  Future<List<ChattingMessage>> fetchMessages(String chattingRoomId) async {
    final result = await _database
        .collection('rooms')
        .doc(chattingRoomId)
        .collection('messages')
        .get();

    return result.docs
        .map((doc) => doc.data()..addAll({'id': doc.id}))
        .map(ChattingMessage.fromJson)
        .toList();
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
