import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_chating/model/model.dart';
import 'package:my_chating/pages/pages.dart';
import 'package:my_chating/routes/route_name.dart';
import 'package:my_chating/utils/constants.dart';

class NewUsers extends StatelessWidget {
  const NewUsers({super.key, required this.newUsers});
  final List<Profile> newUsers;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: newUsers
            .map<Widget>(
              (user) => InkWell(
                onTap: () async {
                  try {
                    final roomId = await BlocProvider.of<RoomCubit>(context)
                        .createRoom(user.id);
                    if (!context.mounted) return;
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRoute.chatRoute,
                      arguments: RoomArgs(roomId, user.username),
                      (_) => false,
                    );
                  } catch (_) {
                    context.showErrorSnackBar(
                        message: 'Failed creating a new room');
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 60,
                    child: Column(
                      children: [
                        CircleAvatar(
                          child: Text(user.username.substring(0, 2)),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          user.username,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
