import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

LazyDatabase openAppConnection() {
  return LazyDatabase(() async {
    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }

    final dir = await getApplicationSupportDirectory();
    final file = File(p.join(dir.path, 'shishur_dinlipi.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

QueryExecutor openMemoryConnection() => NativeDatabase.memory();
