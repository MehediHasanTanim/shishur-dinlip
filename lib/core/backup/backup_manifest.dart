import 'dart:convert';

class BackupFileEntry {
  const BackupFileEntry({
    required this.path,
    required this.size,
    required this.checksumSha256,
  });

  final String path;
  final int size;
  final String checksumSha256;

  Map<String, dynamic> toJson() => {
    'path': path,
    'size': size,
    'checksumSha256': checksumSha256,
  };

  static BackupFileEntry fromJson(Map<String, dynamic> json) {
    return BackupFileEntry(
      path: json['path'] as String,
      size: json['size'] as int? ?? 0,
      checksumSha256: json['checksumSha256'] as String? ?? '',
    );
  }
}

class BackupManifest {
  const BackupManifest({
    required this.formatVersion,
    required this.appVersion,
    required this.databaseSchemaVersion,
    required this.createdAt,
    required this.childCount,
    required this.assetCount,
    required this.files,
    this.childNames = const [],
    this.encrypted = true,
  });

  final int formatVersion;
  final String appVersion;
  final int databaseSchemaVersion;
  final DateTime createdAt;
  final int childCount;
  final int assetCount;
  final List<String> childNames;
  final List<BackupFileEntry> files;
  final bool encrypted;

  Map<String, dynamic> toJson() => {
    'formatVersion': formatVersion,
    'appVersion': appVersion,
    'databaseSchemaVersion': databaseSchemaVersion,
    'createdAt': createdAt.toUtc().toIso8601String(),
    'childCount': childCount,
    'assetCount': assetCount,
    'childNames': childNames,
    'encrypted': encrypted,
    'files': files.map((f) => f.toJson()).toList(),
  };

  String encode() => const JsonEncoder.withIndent('  ').convert(toJson());

  static BackupManifest fromJson(Map<String, dynamic> json) {
    final filesRaw = json['files'];
    final files = <BackupFileEntry>[];
    if (filesRaw is List) {
      for (final item in filesRaw) {
        if (item is Map) {
          files.add(
            BackupFileEntry.fromJson(Map<String, dynamic>.from(item)),
          );
        }
      }
    }
    return BackupManifest(
      formatVersion: json['formatVersion'] as int? ?? 1,
      appVersion: json['appVersion'] as String? ?? '',
      databaseSchemaVersion: json['databaseSchemaVersion'] as int? ?? 0,
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '')?.toUtc() ??
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
      childCount: json['childCount'] as int? ?? 0,
      assetCount: json['assetCount'] as int? ?? 0,
      childNames: (json['childNames'] as List?)
              ?.whereType<String>()
              .toList() ??
          const [],
      encrypted: json['encrypted'] as bool? ?? true,
      files: files,
    );
  }

  static BackupManifest decode(String raw) {
    final decoded = jsonDecode(raw);
    if (decoded is! Map) {
      throw const FormatException('Invalid backup manifest');
    }
    return fromJson(Map<String, dynamic>.from(decoded));
  }
}

class BackupHistoryEntry {
  const BackupHistoryEntry({
    required this.id,
    required this.fileName,
    required this.absolutePath,
    required this.createdAt,
    required this.byteSize,
    this.childCount,
    this.schemaVersion,
  });

  final String id;
  final String fileName;
  final String absolutePath;
  final DateTime createdAt;
  final int byteSize;
  final int? childCount;
  final int? schemaVersion;
}
