import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:my_chating/components/components.dart';
import 'package:my_chating/pages/pages.dart';
import 'package:my_chating/routes/route_name.dart';
import 'package:my_chating/utils/constants.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    Key? key,
    required this.username,
    required this.roomId,
  }) : super(key: key);
  final String roomId;
  final String username;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushNamedAndRemoveUntil(
            AppRoute.entryPointRoute, (route) => false);
        return true;
      },
      child: BlocProvider<ChatCubit>(
        create: (context) => ChatCubit()..setMessagesListener(widget.roomId),
        child: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            appBar: AppBar(
              leading: BackButton(
                onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRoute.entryPointRoute, (route) => false),
              ),
              title: Text(widget.username),
            ),
            body: BlocConsumer<ChatCubit, ChatState>(
              listener: (context, state) {
                if (state is ChatError) {
                  context.showErrorSnackBar(message: state.message);
                }
              },
              builder: (context, state) {
                if (state is ChatInitial) {
                  return preloader;
                } else if (state is ChatLoaded) {
                  final messages = state.messages;
                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          reverse: true,
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final message = messages[index];
                            return ChatBubble(message: message);
                          },
                        ),
                      ),
                      const MessageBar(),
                    ],
                  );
                } else if (state is ChatEmpty) {
                  return const Column(
                    children: [
                      Expanded(
                        child: Center(
                          child: Text('Start your conversation now...'),
                        ),
                      ),
                      MessageBar()
                    ],
                  );
                } else if (state is ChatError) {
                  return Center(child: Text(state.message));
                }
                return Container();
              },
            ),
          ),
        ),
      ),
    );
  }
}
