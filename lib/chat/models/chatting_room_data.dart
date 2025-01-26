class ChattingRoomData {
  const ChattingRoomData(this.id, this.participants);

  ChattingRoomData.fromJson(Map<String, dynamic> data)
      : id = data['id'] as String,
        participants = (data['participants'] as List).cast<String>().toList();

  final String id;
  final List<String> participants;
}
