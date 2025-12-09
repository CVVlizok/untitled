import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../delegates/auth/register_form_cubit.dart';
import '../delegates/profile/profile_cubit.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  void _onRegister(BuildContext context) {
    final form = context.read<RegisterFormCubit>().state;

    final name = form.name.trim();
    final login = form.login.trim();
    final pass = form.password.trim();

    final ok = name.isNotEmpty && login.isNotEmpty && pass.isNotEmpty;

    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Заполните все поля')),
      );
      return;
    }

    context.read<ProfileCubit>().setProfile(name: name, login: login);
    context.read<RegisterFormCubit>().clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Регистрация выполнена, войдите в аккаунт'),
      ),
    );

    context.go('/login');
  }

  void _goLogin(BuildContext context) => context.go('/login');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Регистрация')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<RegisterFormCubit, RegisterFormState>(
          builder: (context, formState) {
            return Column(
              children: [
                TextField(
                  onChanged: (value) =>
                      context.read<RegisterFormCubit>().changeName(value),
                  decoration: const InputDecoration(
                    labelText: 'Имя',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  onChanged: (value) =>
                      context.read<RegisterFormCubit>().changeLogin(value),
                  decoration: const InputDecoration(
                    labelText: 'Логин',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  onChanged: (value) =>
                      context.read<RegisterFormCubit>().changePassword(value),
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
                          context.read<RegisterFormCubit>().toggleObscure(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () => _onRegister(context),
                    icon: const Icon(Icons.person_add),
                    label: const Text('Зарегистрироваться'),
                  ),
                ),
                const SizedBox(height: 12),
                RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: [
                      const TextSpan(text: 'Есть аккаунт? '),
                      TextSpan(
                        text: 'Войти',
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => _goLogin(context),
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
