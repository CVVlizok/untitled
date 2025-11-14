// lib/features/health/bloc/profile/profile_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileState {
  final String name;
  final String login;

  const ProfileState({
    this.name = 'Имя пользователя',
    this.login = 'user@example.com',
  });

  ProfileState copyWith({
    String? name,
    String? login,
  }) {
    return ProfileState(
      name: name ?? this.name,
      login: login ?? this.login,
    );
  }
}

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(const ProfileState());

  void changeName(String newName) {
    emit(state.copyWith(name: newName));
  }

  void changeLogin(String newLogin) {
    emit(state.copyWith(login: newLogin));
  }
}
