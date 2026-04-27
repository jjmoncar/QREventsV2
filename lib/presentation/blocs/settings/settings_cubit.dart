import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit()
      : super(const SettingsState(
          themeMode: ThemeMode.light,
          locale: Locale('es'), // Default to Spanish
        ));

  void toggleTheme() {
    final newMode =
        state.themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    emit(state.copyWith(themeMode: newMode));
  }

  void setTheme(ThemeMode mode) {
    emit(state.copyWith(themeMode: mode));
  }

  void setLocale(Locale locale) {
    emit(state.copyWith(locale: locale));
  }

  bool get isDark => state.themeMode == ThemeMode.dark;
}
