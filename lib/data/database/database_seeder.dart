import 'package:codium/core/config/test_user_config.dart';
import 'package:codium/domain/datasources/i_user_datasource.dart';
import 'package:codium/domain/enums/coin_transaction_type.dart';
import 'package:drift/drift.dart';

import 'app_database.dart';

class DatabaseSeeder {
  final AppDatabase db;
  final IUserDataSource userDataSource;

  DatabaseSeeder(this.db, this.userDataSource);

  Future<void> seed() async {
    await db.transaction(() async {
      final now = DateTime.now();

      final testUser = await userDataSource.create(
        email: TestUserConfig.email,
        password: TestUserConfig.password,
      );

      if (testUser != null) {
        await db
            .into(db.userStatistic)
            .insert(
              UserStatisticCompanion.insert(
                userId: testUser.id,
                lastActiveDate: now,
                currentStreak: const Value(0),
                maxStreak: const Value(0),
                coinBalance: const Value(TestUserConfig.initialBalance),
                experiencePoints: const Value(0),
              ),
            );

        await db
            .into(db.coinTransaction)
            .insert(
              CoinTransactionCompanion.insert(
                userId: testUser.id,
                amount: TestUserConfig.initialBalance,
                type: CoinTransactionType.initialGrant.name,
                relatedEntityId: const Value(null),
                createdAt: now,
              ),
            );
      }

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

      final lesson1Id = await db
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

      final lesson2Id = await db
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

      final lesson3Id = await db
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

      if (testUser != null) {
        await db
            .into(db.userCourse)
            .insert(
              UserCourseCompanion.insert(
                userId: testUser.id,
                courseId: flutterCourseId,
              ),
            );
      }

      await _seedTasksForLessons([lesson1Id, lesson2Id, lesson3Id]);

      print('🎉 Database seeding completed successfully!');
      print('📊 Summary: 2 courses, 3 modules, 3 lessons, 18 tasks');
    });
  }

  Future<void> _seedTasksForLessons(List<int> lessonIds) async {
    print('📝 Creating tasks for ${lessonIds.length} lessons...');

    for (final lessonId in lessonIds) {
      await db
          .into(db.task)
          .insert(
            TaskCompanion.insert(
              lessonId: lessonId,
              taskType: 'multiple_choice',
              questionText: 'What is Flutter?',
              correctAnswer:
                  'A UI toolkit for building natively compiled applications',
              optionsJson: const Value(
                '["A UI toolkit for building natively compiled applications", "A programming language", "A database", "An operating system"]',
              ),
              difficultyLevel: 1,
              xpValue: 10,
              orderIndex: 0,
              topic: 'flutter_basics',
              fallbackHint: const Value(
                'Think about what Flutter helps you build',
              ),
              fallbackExplanation: const Value(
                'Flutter is Google\'s UI toolkit for building beautiful, natively compiled applications for mobile, web, and desktop from a single codebase.',
              ),
              createdAt: DateTime.now(),
            ),
          );

      await db
          .into(db.task)
          .insert(
            TaskCompanion.insert(
              lessonId: lessonId,
              taskType: 'multiple_choice',
              questionText: 'Which programming language does Flutter use?',
              correctAnswer: 'Dart',
              optionsJson: const Value('["Dart", "Java", "Kotlin", "Swift"]'),
              difficultyLevel: 1,
              xpValue: 10,
              orderIndex: 1,
              topic: 'flutter_basics',
              fallbackHint: const Value('It starts with D'),
              fallbackExplanation: const Value(
                'Flutter uses Dart, a client-optimized programming language developed by Google.',
              ),
              createdAt: DateTime.now(),
            ),
          );

      await db
          .into(db.task)
          .insert(
            TaskCompanion.insert(
              lessonId: lessonId,
              taskType: 'code_completion',
              questionText: 'Complete the code to create a simple Flutter app:',
              correctAnswer: 'MaterialApp',
              codeTemplate: const Value(
                'import \'package:flutter/material.dart\';\n\nvoid main() {\n  runApp(___(\n    home: Scaffold(\n      body: Center(child: Text(\'Hello\')),\n    ),\n  ));\n}',
              ),
              programmingLanguage: const Value('dart'),
              difficultyLevel: 2,
              xpValue: 20,
              orderIndex: 2,
              topic: 'flutter_basics',
              fallbackHint: const Value(
                'You need a Material Design app wrapper',
              ),
              fallbackExplanation: const Value(
                'MaterialApp is the root widget that provides Material Design styling and navigation.',
              ),
              createdAt: DateTime.now(),
            ),
          );

      await db
          .into(db.task)
          .insert(
            TaskCompanion.insert(
              lessonId: lessonId,
              taskType: 'multiple_choice',
              questionText: 'What is a Widget in Flutter?',
              correctAnswer: 'Everything in Flutter UI',
              optionsJson: const Value(
                '["Everything in Flutter UI", "Only buttons", "Only text fields", "Only containers"]',
              ),
              difficultyLevel: 1,
              xpValue: 10,
              orderIndex: 3,
              topic: 'widgets',
              fallbackHint: const Value('Widgets are the building blocks'),
              fallbackExplanation: const Value(
                'In Flutter, everything is a widget - from layout structures to styling to interactive elements.',
              ),
              createdAt: DateTime.now(),
            ),
          );

      await db
          .into(db.task)
          .insert(
            TaskCompanion.insert(
              lessonId: lessonId,
              taskType: 'multiple_choice',
              questionText: 'Which widget is used for layout in a column?',
              correctAnswer: 'Column',
              optionsJson: const Value(
                '["Column", "Row", "Stack", "Container"]',
              ),
              difficultyLevel: 2,
              xpValue: 15,
              orderIndex: 4,
              topic: 'layout',
              fallbackHint: const Value('Think vertical arrangement'),
              fallbackExplanation: const Value(
                'Column widget arranges its children vertically from top to bottom.',
              ),
              createdAt: DateTime.now(),
            ),
          );

      await db
          .into(db.task)
          .insert(
            TaskCompanion.insert(
              lessonId: lessonId,
              taskType: 'text_input',
              questionText: 'What method is used to run a Flutter app?',
              correctAnswer: 'runApp',
              difficultyLevel: 1,
              xpValue: 10,
              orderIndex: 5,
              topic: 'flutter_basics',
              fallbackHint: const Value('It starts with "run"'),
              fallbackExplanation: const Value(
                'runApp() is the entry point that takes a Widget and makes it the root of the widget tree.',
              ),
              createdAt: DateTime.now(),
            ),
          );
    }
  }

  Future<void> ensureTestUser() async {
    await db.transaction(() async {
      final now = DateTime.now();
      final existingUser = await userDataSource.getUserByEmail(
        TestUserConfig.email,
      );

      if (existingUser == null) {
        final testUser = await userDataSource.create(
          email: TestUserConfig.email,
          password: TestUserConfig.password,
        );

        if (testUser == null) {
          return;
        }

        await db
            .into(db.userStatistic)
            .insert(
              UserStatisticCompanion.insert(
                userId: testUser.id,
                lastActiveDate: now,
                currentStreak: const Value(0),
                maxStreak: const Value(0),
                coinBalance: const Value(TestUserConfig.initialBalance),
                experiencePoints: const Value(0),
              ),
            );

        await db
            .into(db.coinTransaction)
            .insert(
              CoinTransactionCompanion.insert(
                userId: testUser.id,
                amount: TestUserConfig.initialBalance,
                type: CoinTransactionType.initialGrant.name,
                relatedEntityId: const Value(null),
                createdAt: now,
              ),
            );
        return;
      }

      final expectedHash = userDataSource.hashPassword(TestUserConfig.password);
      if (existingUser.passwordHash != expectedHash) {
        await userDataSource.updateUser(
          UserCompanion(
            id: Value(existingUser.id),
            passwordHash: Value(expectedHash),
          ),
        );
      }
    });
  }
}
