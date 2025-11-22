part of 'theme_cubit.dart';

class ThemeState extends Equatable {
  const ThemeState(this.isDarkTheme);

  final bool isDarkTheme;

  @override
  List<Object> get props => [isDarkTheme];
}
