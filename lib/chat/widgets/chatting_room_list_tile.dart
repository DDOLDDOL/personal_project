import 'package:flutter/material.dart';
import 'package:personal_project/chat/chat.dart';

class ChattingRoomListTile extends StatelessWidget {
  const ChattingRoomListTile({
    super.key,
    required this.roomData,
  });

  final ChattingRoomData roomData;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ChattingScreen(roomData: roomData),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/images/app-icon.png',
                width: 40,
                height: 40,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                roomData.participantsToString,
                style: const TextStyle(fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
