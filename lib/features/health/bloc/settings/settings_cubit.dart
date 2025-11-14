import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsState {
  final bool isDark;
  final String lang;

  const SettingsState({
    this.isDark = false,
    this.lang = 'ru',
  });

  SettingsState copyWith({
    bool? isDark,
    String? lang,
  }) {
    return SettingsState(
      isDark: isDark ?? this.isDark,
      lang: lang ?? this.lang,
    );
  }
}

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(const SettingsState());

  void toggleDark(bool value) {
    emit(state.copyWith(isDark: value));
  }

  void changeLang(String lang) {
    emit(state.copyWith(lang: lang));
  }
}
