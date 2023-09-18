import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_chating/pages/pages.dart';
import 'package:my_chating/utils/constants.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key, required this.userId});
  final String userId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfilesCubit, ProfilesState>(builder: (context, state) {
      if (state is ProfilesLoaded) {
        final user = state.profiles[userId];
        return CircleAvatar(
          child: user == null ? preloader : Text(user.username.substring(0, 2)),
        );
      } else {
        return const CircleAvatar(child: preloader);
      }
    });
  }
}
