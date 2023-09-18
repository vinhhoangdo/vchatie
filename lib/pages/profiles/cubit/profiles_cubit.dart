import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_chating/model/model.dart';
import 'package:my_chating/utils/constants.dart';

part 'profiles_state.dart';

class ProfilesCubit extends Cubit<ProfilesState> {
  ProfilesCubit() : super(ProfilesInitial());

  /// Map of app users cache in memory with profile_id as the key
  final Map<String, Profile?> _profiles = {};

  Future<void> getProfile(String userId) async {
    if (_profiles[userId] != null) {
      return;
    }
    final data =
        await supabase.from('profiles').select().match({'id': userId}).single();
    if (data == null) {
      return;
    }
    _profiles[userId] = Profile.fromMap(data);
    emit(ProfilesLoaded(profiles: _profiles));
  }
}
