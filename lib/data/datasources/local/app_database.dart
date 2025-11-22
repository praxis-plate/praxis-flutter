import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../../core/config/env_config.dart';
import 'drift_tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [PdfBooks, Bookmarks, Explanations, Users, UserStatisticsTable],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        await m.createTable(users);
      }
    },
  );

  static QueryExecutor _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, EnvConfig.dbPath));

      if (await file.exists()) {
        await file.delete();
      }

      return NativeDatabase(file);
    });
  }
}
