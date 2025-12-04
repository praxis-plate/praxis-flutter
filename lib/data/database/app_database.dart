import 'dart:io';

import 'package:codium/core/config/env_config.dart';
import 'package:codium/data/database/tables/tables.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    PdfBook,
    Bookmark,
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
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
  );

  static QueryExecutor _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, EnvConfig.dbPath));

      return NativeDatabase.createInBackground(
        file,
        setup: (database) {
          database.execute('PRAGMA foreign_keys = ON');
        },
      );
    });
  }
}
