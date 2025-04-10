import 'package:cloud_firestore/cloud_firestore.dart';

// TODO: 현재는 1:1 DM 기반의 메시지 모델입니다. 추후에 단톡방에 적용 가능한 메시지 모델을 만들어야 합니다.
class ChattingMessage {
  const ChattingMessage(
    this.id,
    this.text,
    this.sender,
    this.dateTime,
    this.readers, {
    required this.isPending,
  });

  const ChattingMessage.pending(
    this.text,
    this.sender,
  )   : id = '',
        dateTime = null,
        isPending = true,
        readers = const [];

  ChattingMessage.fromJson(Map<String, dynamic> data)
      : id = data['id'] as String,
        text = data['text'] as String,
        sender = data['sender'] as String,
        dateTime = (data['createdAt'] as Timestamp).toDate(),
        readers = (data['readers'] as List).cast<String>().toList(),
        isPending = false;

  final String id;
  final String text;
  final String sender;
  final DateTime? dateTime;
  final List<String> readers; // 메시지를 읽은 유저들
  final bool isPending;
}
