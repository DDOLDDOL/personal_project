import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_project/chat/chat.dart';

class MessageBalloon extends StatelessWidget {
  const MessageBalloon({
    super.key,
    required this.message,
    required this.isMine,
  });

  final ChattingMessage message;
  final bool isMine;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // if (message.isPending)
            //   SizedBox(
            //     width: 16,
            //     height: 16,
            //     child: CircularProgressIndicator(color: Colors.grey.shade300),
            //   ),
            // const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isMine ? Colors.white : Colors.teal.shade100,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Text(message.text),
            ),
          ],
        ),
        if (message.dateTime != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(DateFormat('HH:mm').format(message.dateTime!)),
          ),
      ],
    );
  }
}
