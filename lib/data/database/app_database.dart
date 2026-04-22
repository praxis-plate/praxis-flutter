import 'dart:io';

import 'package:praxis/core/config/env_config.dart';
import 'package:praxis/data/database/tables/tables.dart';
import 'package:praxis/domain/enums/task_type.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Explanation,
    User,
    UserCourse,
    UserStatistic,
    LessonProgress,
    Achievement,
    UserAchievement,
    CoinTransaction,
    Course,
    Module,
    Lesson,
    Task,
    TaskProgress,
    TaskOption,
    TaskTestCase,
  ],
)
class AppDatabase extends _$AppDatabase {
  static const int _currentSchemaVersion = 2;

  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => _currentSchemaVersion;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }

  static QueryExecutor _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, EnvConfig.dbPath));
      return NativeDatabase(file);
    });
  }
}
