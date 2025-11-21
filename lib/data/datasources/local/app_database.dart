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

  static QueryExecutor _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, EnvConfig.dbPath));
      return NativeDatabase(file);
    });
  }
}
