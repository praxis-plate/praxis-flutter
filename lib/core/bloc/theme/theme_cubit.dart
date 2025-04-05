import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit(bool value) : super(ThemeState(value));

  void setDarkTheme(bool value) {
    emit(ThemeState(value));
  }
}
