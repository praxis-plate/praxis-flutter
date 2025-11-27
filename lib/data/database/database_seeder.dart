import 'package:drift/drift.dart';

import 'app_database.dart';

class DatabaseSeeder {
  final AppDatabase db;

  DatabaseSeeder(this.db);

  Future<void> seed() async {
    await db.transaction(() async {
      final now = DateTime.now();

      final flutterCourseId = await db
          .into(db.course)
          .insert(
            CourseCompanion.insert(
              title: 'Flutter Fundamentals',
              description:
                  'Learn the basics of Flutter development, including widgets, state management, and navigation.',
              author: 'Google Team',
              category: 'Mobile Development',
              priceInCoins: 500,
              durationMinutes: 180,
              rating: const Value(4.8),
              createdAt: now,
            ),
          );

      final dartCourseId = await db
          .into(db.course)
          .insert(
            CourseCompanion.insert(
              title: 'Advanced Dart',
              description:
                  'Master advanced Dart concepts including async programming and streams.',
              author: 'Uncle Bob',
              category: 'Programming',
              priceInCoins: 750,
              durationMinutes: 240,
              rating: const Value(4.9),
              createdAt: now,
            ),
          );

      final modFlutter1Id = await db
          .into(db.module)
          .insert(
            ModuleCompanion.insert(
              courseId: flutterCourseId,
              title: 'Introduction',
              description: 'Setup and Hello World',
              orderIndex: 0,
              createdAt: now,
            ),
          );

      final modFlutter2Id = await db
          .into(db.module)
          .insert(
            ModuleCompanion.insert(
              courseId: flutterCourseId,
              title: 'Widgets Deep Dive',
              description: 'Row, Column, Stack',
              orderIndex: 1,
              createdAt: now,
            ),
          );

      final modDart1Id = await db
          .into(db.module)
          .insert(
            ModuleCompanion.insert(
              courseId: dartCourseId,
              title: 'Async Programming',
              description: 'Futures and Streams',
              orderIndex: 0,
              createdAt: now,
            ),
          );

      await db
          .into(db.lesson)
          .insert(
            LessonCompanion.insert(
              moduleId: modFlutter1Id,
              title: 'What is Flutter?',
              contentText: 'Flutter is Google\'s UI toolkit...',
              orderIndex: 0,
              durationMinutes: 10,
              createdAt: now,
            ),
          );

      await db
          .into(db.lesson)
          .insert(
            LessonCompanion.insert(
              moduleId: modFlutter2Id,
              title: 'Install SDK',
              contentText: 'How to install Flutter on Mac/Windows...',
              videoUrl: const Value('https://youtu.be/example'),
              orderIndex: 1,
              durationMinutes: 15,
              createdAt: now,
            ),
          );

      await db
          .into(db.lesson)
          .insert(
            LessonCompanion.insert(
              moduleId: modDart1Id,
              title: 'Understanding Futures',
              contentText: 'A Future is used to represent a potential value...',
              orderIndex: 0,
              durationMinutes: 20,
              createdAt: now,
            ),
          );

      await db
          .into(db.achievement)
          .insert(
            AchievementCompanion.insert(
              title: 'Flutter Master',
              description: 'Complete the Flutter Fundamentals course',
              iconUrl: const Value('assets/icons/flutter_medal.png'),
              pointsReward: const Value(100),
              conditionType: 'COURSE_COMPLETED',
              conditionValue: const Value(null),
              relatedCourseId: Value(flutterCourseId),
            ),
          );

      await db
          .into(db.achievement)
          .insert(
            AchievementCompanion.insert(
              title: 'Dart Ninja',
              description: 'Finish Advanced Dart course',
              iconUrl: const Value(null),
              pointsReward: const Value(150),
              conditionType: 'COURSE_COMPLETED',
              conditionValue: const Value(null),
              relatedCourseId: Value(dartCourseId),
            ),
          );

      await db
          .into(db.achievement)
          .insert(
            AchievementCompanion.insert(
              title: 'Welcome Aboard',
              description: 'Log in for the first time',
              iconUrl: const Value(null),
              pointsReward: const Value(10),
              conditionType: 'FIRST_LOGIN',
              conditionValue: const Value(null),
              relatedCourseId: const Value(null),
            ),
          );

      await db
          .into(db.achievement)
          .insert(
            AchievementCompanion.insert(
              title: 'Consistency is Key',
              description: 'Maintain a 3-day streak',
              iconUrl: const Value(null),
              pointsReward: const Value(50),
              conditionType: 'STREAK_DAYS',
              conditionValue: const Value('3'),
              relatedCourseId: const Value(null),
            ),
          );
    }); // end transaction
  }
}
