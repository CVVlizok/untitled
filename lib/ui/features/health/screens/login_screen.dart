import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../data/datasources/auth_secure_data_source.dart';
import '../delegates/auth/login_form_cubit.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Future<void> _onLogin(BuildContext context) async {
    final form = context.read<LoginFormCubit>().state;
    final login = form.login.trim();
    final pass = form.password.trim();

    if (login.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введите логин и пароль')),
      );
      return;
    }

    try {
      // Проверяем учетные данные
      final authStorage = getIt<AuthSecureDataSource>();
      final isValid = await authStorage.validateCredentials(login, pass);
      
      if (!isValid) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Неверный логин или пароль')),
        );
        return;
      }
      
      // Генерируем простой токен (в реальном приложении это делал бы сервер)
      final token = 'token_${DateTime.now().millisecondsSinceEpoch}_$login';
      await authStorage.saveToken(token);

      context.read<LoginFormCubit>().clear();
      context.go('/profile');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка входа: $e')),
      );
    }
  }

  void _goRegister(BuildContext context) => context.go('/register');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Вход')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<LoginFormCubit, LoginFormState>(
          builder: (context, formState) {
            return Column(
              children: [
                TextField(
                  onChanged: (value) =>
                      context.read<LoginFormCubit>().changeLogin(value),
                  decoration: const InputDecoration(
                    labelText: 'Логин',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  onChanged: (value) =>
                      context.read<LoginFormCubit>().changePassword(value),
                  obscureText: formState.obscure,
                  decoration: InputDecoration(
                    labelText: 'Пароль',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        formState.obscure
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () =>
                          context.read<LoginFormCubit>().toggleObscure(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _onLogin(context),
                    icon: const Icon(Icons.login),
                    label: const Text('Войти'),
                  ),
                ),
                const SizedBox(height: 12),
                RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: [
                      const TextSpan(text: 'Нет аккаунта? '),
                      TextSpan(
                        text: 'Регистрация',
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => _goRegister(context),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
