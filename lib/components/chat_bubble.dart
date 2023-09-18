import 'package:flutter/material.dart';
import 'package:my_chating/model/model.dart';
import 'package:timeago/timeago.dart';

import 'user_avatart.dart';

class ChatBubble extends StatefulWidget {
  const ChatBubble({
    super.key,
    required this.message,
  });
  final Message message;

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  bool isShowTime = false;
  @override
  Widget build(BuildContext context) {
    List<Widget> chatContents = [
      if (!widget.message.isMine) UserAvatar(userId: widget.message.profileId),
      const SizedBox(width: 12),
      Flexible(
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 12.0,
          ),
          decoration: BoxDecoration(
            color: widget.message.isMine
                ? Theme.of(context).primaryColor
                : Colors.grey[300],
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Text(
            widget.message.content,
            style: TextStyle(
              color: widget.message.isMine ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
      const SizedBox(width: 12),
      if (widget.message.id == 'new')
        Text(format(widget.message.createdAt, locale: 'en_short')),
      const SizedBox(width: 60),
    ];
    if (widget.message.isMine) {
      chatContents = chatContents.reversed.toList();
    }

    return GestureDetector(
      onDoubleTap: () => setState(() {
        isShowTime = !isShowTime;
      }),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
        child: transform(_buildChatContainer(chatContents)),
      ),
    );
  }

  Widget transform(Widget child) {
    return Transform.translate(
      offset: Offset(0, isShowTime ? -10 : 0),
      child: Column(
        crossAxisAlignment: widget.message.isMine
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          child,
          if (isShowTime)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8.0),
              child: Text(
                format(widget.message.createdAt,
                    locale: 'en', allowFromNow: true),
                style: const TextStyle(color: Colors.grey),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildChatContainer(List<Widget> chatContents) => Row(
        mainAxisAlignment: widget.message.isMine
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: chatContents,
      );
}
