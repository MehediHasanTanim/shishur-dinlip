import 'package:flutter/foundation.dart';

abstract final class FamilyEventTypes {
  static const eid = 'eid';
  static const wedding = 'wedding';
  static const vacation = 'vacation';
  static const grandparentVisit = 'grandparent_visit';
  static const newSibling = 'new_sibling';
  static const movingHome = 'moving_home';
  static const firstFlight = 'first_flight';
  static const firstBeach = 'first_beach';
  static const gathering = 'gathering';
  static const other = 'other';

  static const List<String> all = [
    eid,
    wedding,
    vacation,
    grandparentVisit,
    newSibling,
    movingHome,
    firstFlight,
    firstBeach,
    gathering,
    other,
  ];
}

@immutable
class FamilyEvent {
  const FamilyEvent({
    required this.id,
    required this.childId,
    required this.eventType,
    required this.title,
    required this.eventDate,
    required this.createdAt,
    required this.updatedAt,
    this.locationText,
    this.story,
    this.childReaction,
    this.coverAssetId,
    this.albumId,
    this.isFavorite = false,
    this.deletedAt,
  });

  final String id;
  final String childId;
  final String eventType;
  final String title;
  final DateTime eventDate;
  final String? locationText;
  final String? story;
  final String? childReaction;
  final String? coverAssetId;
  final String? albumId;
  final bool isFavorite;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  FamilyEvent copyWith({
    String? id,
    String? childId,
    String? eventType,
    String? title,
    DateTime? eventDate,
    String? locationText,
    bool clearLocationText = false,
    String? story,
    bool clearStory = false,
    String? childReaction,
    bool clearChildReaction = false,
    String? coverAssetId,
    bool clearCoverAssetId = false,
    String? albumId,
    bool clearAlbumId = false,
    bool? isFavorite,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    bool clearDeletedAt = false,
  }) {
    return FamilyEvent(
      id: id ?? this.id,
      childId: childId ?? this.childId,
      eventType: eventType ?? this.eventType,
      title: title ?? this.title,
      eventDate: eventDate ?? this.eventDate,
      locationText: clearLocationText
          ? null
          : (locationText ?? this.locationText),
      story: clearStory ? null : (story ?? this.story),
      childReaction: clearChildReaction
          ? null
          : (childReaction ?? this.childReaction),
      coverAssetId: clearCoverAssetId
          ? null
          : (coverAssetId ?? this.coverAssetId),
      albumId: clearAlbumId ? null : (albumId ?? this.albumId),
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: clearDeletedAt ? null : (deletedAt ?? this.deletedAt),
    );
  }
}
