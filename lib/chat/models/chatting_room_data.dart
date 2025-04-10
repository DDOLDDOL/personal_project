import 'package:personal_project/common/common.dart';

class ChattingRoomData {
  const ChattingRoomData(
    this.id,
    this.lastMessage,
    this.uncheckedMessagesCount,
    this.participants,
  );

  ChattingRoomData.empty(String withWhom)
      : id = '',
        lastMessage = '',
        uncheckedMessagesCount = 0,
        participants = [withWhom];

  ChattingRoomData.fromJson(Map<String, dynamic> data)
      : id = data['id'] as String,
        lastMessage = data['lastMessage'] as String,
        uncheckedMessagesCount = data['uncheckedMessagesCount'] as int,
        participants = (data['participants'] as List)
            .cast<String>()
            .where((participant) => participant != AuthHive.instance.email)
            .toList();

  final String id;
  final String lastMessage;
  final int uncheckedMessagesCount;
  final List<String> participants;

  String get participantsToString {
    return participants.reduce((previous, current) => '$previous, $current');
  }
}
