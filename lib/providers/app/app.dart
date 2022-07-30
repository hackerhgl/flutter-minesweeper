import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appProvider = StateNotifierProvider<_AppNotifier, AppState>((ref) {
  return _AppNotifier();
});

class _AppNotifier extends StateNotifier<AppState> {
  _AppNotifier() : super(AppStateDefault());

  void init() {
    state = AppStateInit();
  }

  void def() {
    state = AppStateDefault();
  }
}

@immutable
class AppState {
  final String theme;
  final String locale;

  const AppState({
    this.theme = 'light',
    this.locale = 'en',
  });

  AppState copyWith({
    String? theme,
    String? locale,
  }) {
    return AppState(
      theme: theme ?? this.theme,
      locale: locale ?? this.locale,
    );
  }
}

@immutable
class AppStateDefault extends AppState {}

@immutable
class AppStateInit extends AppState {}
