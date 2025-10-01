import 'package:ai_transport/main.dart';
import 'package:ai_transport/src/core/database/cache/shared_pref_helper.dart';
import 'package:ai_transport/src/feature/profile/presentation/view_models/cubit/language_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LanguageCubit extends Cubit<LanguageState> {
  LanguageCubit() : super(const LanguageInitial(Locale('en')));

  void changeLanguage(Locale locale) {
    SharedPrefHelper.setData(StorageKeys.Language, locale.languageCode);
    emit(LanguageChanged(locale));
  }

  void loadSavedLanguage() {
    final code = SharedPrefHelper.getString(StorageKeys.Language);
    if (code.isNotEmpty) {
      emit(LanguageChanged(Locale(code)));
    } else {
      emit(const LanguageChanged(Locale('en'))); 
    }
  }
}
