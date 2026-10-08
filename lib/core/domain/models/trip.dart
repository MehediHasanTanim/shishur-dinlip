import 'package:flutter/foundation.dart';

abstract final class TripTypes {
  static const vacation = 'vacation';
  static const firstFlight = 'first_flight';
  static const firstBeach = 'first_beach';
  static const placeVisit = 'place_visit';
  static const other = 'other';

  static const List<String> all = [
    vacation,
    firstFlight,
    firstBeach,
    placeVisit,
    other,
  ];
}

@immutable
class Trip {
  const Trip({
    required this.id,
    required this.childId,
    required this.tripType,
    required this.title,
    required this.placeName,
    required this.startDate,
    required this.createdAt,
    required this.updatedAt,
    this.endDate,
    this.story,
    this.childReaction,
    this.coverAssetId,
    this.albumId,
    this.isFavorite = false,
    this.deletedAt,
  });

  final String id;
  final String childId;
  final String tripType;
  final String title;
  final String placeName;
  final DateTime startDate;
  final DateTime? endDate;
  final String? story;
  final String? childReaction;
  final String? coverAssetId;
  final String? albumId;
  final bool isFavorite;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  Trip copyWith({
    String? id,
    String? childId,
    String? tripType,
    String? title,
    String? placeName,
    DateTime? startDate,
    DateTime? endDate,
    bool clearEndDate = false,
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
    return Trip(
      id: id ?? this.id,
      childId: childId ?? this.childId,
      tripType: tripType ?? this.tripType,
      title: title ?? this.title,
      placeName: placeName ?? this.placeName,
      startDate: startDate ?? this.startDate,
      endDate: clearEndDate ? null : (endDate ?? this.endDate),
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
