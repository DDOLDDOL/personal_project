import 'package:cloud_firestore/cloud_firestore.dart';

class BackendServer {
  BackendServer() : _database = FirebaseFirestore.instance;

  late final FirebaseFirestore _database;

  Future<void> sendMessage(
    String chattingRoomId,
    String message,
    String senderId,
  ) async {
    final result = await _database
        .collection('rooms')
        .doc(chattingRoomId)
        .collection('messages')
        .add({
      'text': message,
      'createdAt': DateTime.now(),
      'sender': senderId,
    }).then(
      (r) => print(r),
      onError: (e) => print("Error completing: $e"),
    );
  }
}
