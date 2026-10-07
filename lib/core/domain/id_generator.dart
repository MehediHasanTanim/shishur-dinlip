import 'package:uuid/uuid.dart';

/// Generates UUID v4 identifiers for all persisted entities.
class IdGenerator {
  const IdGenerator({Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  final Uuid _uuid;

  String next() => _uuid.v4();
}

const idGenerator = IdGenerator();
