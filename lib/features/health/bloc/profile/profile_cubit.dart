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

  void changeName(String name) {
    emit(state.copyWith(name: name));
  }

  void changeLogin(String login) {
    emit(state.copyWith(login: login));
  }

  void setProfile({required String name, required String login}) {
    emit(ProfileState(name: name, login: login));
  }
}