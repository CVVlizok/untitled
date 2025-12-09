import 'package:flutter_bloc/flutter_bloc.dart';

class LoginFormState {
  final String login;
  final String password;
  final bool obscure;

  const LoginFormState({
    this.login = '',
    this.password = '',
    this.obscure = true,
  });

  LoginFormState copyWith({
    String? login,
    String? password,
    bool? obscure,
  }) {
    return LoginFormState(
      login: login ?? this.login,
      password: password ?? this.password,
      obscure: obscure ?? this.obscure,
    );
  }
}

class LoginFormCubit extends Cubit<LoginFormState> {
  LoginFormCubit() : super(const LoginFormState());

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
    emit(const LoginFormState());
  }
}
