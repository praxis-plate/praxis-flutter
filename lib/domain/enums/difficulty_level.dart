enum DifficultyLevel {
  beginner(1),
  elementary(2),
  intermediate(3),
  advanced(4),
  expert(5);

  final int value;

  const DifficultyLevel(this.value);

  static DifficultyLevel fromValue(int value) {
    return DifficultyLevel.values.firstWhere(
      (level) => level.value == value,
      orElse: () => DifficultyLevel.beginner,
    );
  }
}
