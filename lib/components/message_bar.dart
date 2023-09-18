import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_chating/pages/chat/cubit/chat_cubit.dart';
import 'package:my_chating/utils/constants.dart';

class MessageBar extends StatefulWidget {
  const MessageBar({super.key});

  @override
  State<MessageBar> createState() => _MessageBarState();
}

class _MessageBarState extends State<MessageBar> {
  late final TextEditingController _controller;
  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submitMessage() async {
    final text = _controller.text;
    if (text.isEmpty) {
      return;
    }
    context.read<ChatCubit>().sendMessage(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(12.0),
        topRight: Radius.circular(12.0),
      ),
      color: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _controller,
                keyboardType: TextInputType.text,
                maxLines: null,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Type a message',
                  border: outlineBorder,
                  focusedBorder: outlineBorder,
                  contentPadding: const EdgeInsets.all(8.0),
                ),
              ),
            ),
            IconButton(
              onPressed: () => _submitMessage(),
              icon: const Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }
}
