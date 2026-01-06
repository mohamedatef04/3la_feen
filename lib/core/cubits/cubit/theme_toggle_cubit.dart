import 'package:ala_feen/core/theme/app_theme.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

class ThemeToggleCubit extends Cubit<ThemeData> {
  ThemeToggleCubit() : super(AppTheme.getLightTheme());

  void toggleTheme() {
    if (state.brightness == Brightness.light) {
      emit(AppTheme.getDarkTheme());
    } else {
      emit(AppTheme.getLightTheme());
    }
  }
}
