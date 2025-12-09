import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterFormState {
  final String name;
  final String login;
  final String password;
  final bool obscure;

  const RegisterFormState({
    this.name = '',
    this.login = '',
    this.password = '',
    this.obscure = true,
  });

  RegisterFormState copyWith({
    String? name,
    String? login,
    String? password,
    bool? obscure,
  }) {
    return RegisterFormState(
      name: name ?? this.name,
      login: login ?? this.login,
      password: password ?? this.password,
      obscure: obscure ?? this.obscure,
    );
  }
}

class RegisterFormCubit extends Cubit<RegisterFormState> {
  RegisterFormCubit() : super(const RegisterFormState());

  void changeName(String value) {
    emit(state.copyWith(name: value));
  }

  void changeLogin(String value) {
    emit(state.copyWith(login: value));
  }

  void changePassword(String value) {
    emit(state.copyWith(password: value));
  }

  void toggleObscure() {
    emit(state.copyWith(obscure: !state.obscure));
  }

  void clear() {
    emit(const RegisterFormState());
  }
}
