import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/core/models/profile.dart';
import 'package:untitled/domain/usecases/profile/get_profile.dart';
import 'package:untitled/domain/usecases/profile/update_profile_name.dart';
import 'package:untitled/domain/usecases/profile/update_profile_login.dart';

class ProfileState {
  final Profile? profile;
  final bool isLoading;
  final String? error;

  const ProfileState({
    this.profile,
    this.isLoading = false,
    this.error,
  });

  ProfileState copyWith({
    Profile? profile,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfile _getProfile;
  final UpdateProfileName _updateProfileName;
  final UpdateProfileLogin _updateProfileLogin;

  ProfileCubit(
    this._getProfile,
    this._updateProfileName,
    this._updateProfileLogin,
  ) : super(const ProfileState());

  Future<void> loadProfile() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final profile = await _getProfile();
      emit(state.copyWith(
        profile: profile,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> changeName(String name) async {
    try {
      await _updateProfileName(name);
      await loadProfile();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> changeLogin(String login) async {
    try {
      await _updateProfileLogin(login);
      await loadProfile();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> setProfile({required String name, required String login}) async {
    try {
      await _updateProfileName(name);
      await _updateProfileLogin(login);
      await loadProfile();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
