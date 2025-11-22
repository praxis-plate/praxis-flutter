import 'package:codium/domain/models/models.dart';

var mockUserStatistics = UserStatistics(
  userId: 'mock_1',
  currentStreak: 3,
  maxStreak: 7,
  points: 500,
  lastActiveDate: DateTime.now().subtract(const Duration(days: 1)),
  courses: {
  },
);
