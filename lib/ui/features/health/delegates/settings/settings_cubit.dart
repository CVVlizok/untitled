import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../data/datasources/shared_prefs_data_source.dart';

class SettingsState {
  final bool isDark;
  final String lang;
  final bool isLoading;

  const SettingsState({
    this.isDark = false,
    this.lang = 'ru',
    this.isLoading = false,
  });

  SettingsState copyWith({
    bool? isDark,
    String? lang,
    bool? isLoading,
  }) {
    return SettingsState(
      isDark: isDark ?? this.isDark,
      lang: lang ?? this.lang,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class SettingsCubit extends Cubit<SettingsState> {
  final SharedPrefsDataSource _sharedPrefs;

  SettingsCubit(this._sharedPrefs) : super(const SettingsState()) {
    _loadSettings();
  }

  // Загрузка настроек при инициализации
  Future<void> _loadSettings() async {
    emit(state.copyWith(isLoading: true));
    try {
      final isDark = await _sharedPrefs.getThemeDark() ?? false;
      final lang = await _sharedPrefs.getLanguage() ?? 'ru';
      emit(state.copyWith(
        isDark: isDark,
        lang: lang,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      // В случае ошибки используем значения по умолчанию
    }
  }

  // Переключение темы с сохранением
  Future<void> toggleDark(bool value) async {
    emit(state.copyWith(isDark: value));
    try {
      await _sharedPrefs.saveThemeDark(value);
    } catch (e) {
      // В случае ошибки возвращаем предыдущее значение
      emit(state.copyWith(isDark: !value));
    }
  }

  // Изменение языка с сохранением
  Future<void> changeLang(String lang) async {
    emit(state.copyWith(lang: lang));
    try {
      await _sharedPrefs.saveLanguage(lang);
    } catch (e) {
      // В случае ошибки возвращаем предыдущее значение
      emit(state.copyWith(lang: state.lang));
    }
  }
}
