part of 'theme_cubit.dart';

class ThemeState extends Equatable {
  const ThemeState(this.isDarkTheme);

  final bool isDarkTheme;

  ThemeData get currentTheme => isDarkTheme
      ? AppTheme.of(Brightness.dark)
      : AppTheme.of(Brightness.light);

  @override
  List<Object> get props => [isDarkTheme];
}
