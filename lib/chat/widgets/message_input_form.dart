import 'package:flutter/material.dart';
import 'package:personal_project/common/widgets/text_input_field.dart';

class MessageInputForm extends StatefulWidget {
  const MessageInputForm({
    super.key,
    required this.onSend,
    this.loadingWhen = false,
  });

  final void Function(String) onSend;
  final bool loadingWhen;

  @override
  State<MessageInputForm> createState() => _MessageInputFormState();
}

class _MessageInputFormState extends State<MessageInputForm> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 56,
            color: Colors.grey.shade100,
            child: TextInputField(controller: _controller),
          ),
        ),
        GestureDetector(
          onTap: () {
            if (widget.loadingWhen) return;
            if (_controller.text.isEmpty) return;

            widget.onSend(_controller.text);
            _controller.clear();
          },
          child: Container(
            height: 56,
            color: Colors.teal,
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Center(
                child: widget.loadingWhen
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Icon(Icons.send, color: Colors.white),
              ),
            ),
          ),
        )
      ],
    );
  }
}
