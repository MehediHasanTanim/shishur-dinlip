import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shishur_dinlipi/core/domain/models/album.dart';

enum YearReviewSection {
  growth,
  milestones,
  school,
  achievements,
  funnyMoments,
  photos,
  birthday,
  journals,
  health,
  parentLetter,
}

@immutable
class YearReviewItem {
  const YearReviewItem({
    required this.id,
    required this.section,
    required this.title,
    required this.eventDate,
    this.subtitle,
    this.caption,
    this.mediaAssetId,
    this.entityType,
    this.entityId,
    this.included = true,
    this.sortOrder = 0,
    this.priority = 50,
    this.score = 0,
    this.checksum,
  });

  final String id;
  final YearReviewSection section;
  final String title;
  final String? subtitle;
  final String? caption;
  final DateTime eventDate;
  final String? mediaAssetId;
  final String? entityType;
  final String? entityId;
  final bool included;
  final int sortOrder;
  final int priority;

  /// Smart highlight score (higher = stronger candidate).
  final double score;

  /// Optional media checksum used for duplicate photo removal.
  final String? checksum;

  YearReviewItem copyWith({
    String? caption,
    bool? included,
    int? sortOrder,
    String? title,
    String? subtitle,
    double? score,
    String? checksum,
  }) {
    return YearReviewItem(
      id: id,
      section: section,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      caption: caption ?? this.caption,
      eventDate: eventDate,
      mediaAssetId: mediaAssetId,
      entityType: entityType,
      entityId: entityId,
      included: included ?? this.included,
      sortOrder: sortOrder ?? this.sortOrder,
      priority: priority,
      score: score ?? this.score,
      checksum: checksum ?? this.checksum,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'section': section.name,
    'title': title,
    'subtitle': subtitle,
    'caption': caption,
    'eventDate': eventDate.toIso8601String(),
    'mediaAssetId': mediaAssetId,
    'entityType': entityType,
    'entityId': entityId,
    'included': included,
    'sortOrder': sortOrder,
    'priority': priority,
    'score': score,
    'checksum': checksum,
  };

  static YearReviewItem fromJson(Map<String, dynamic> json) {
    return YearReviewItem(
      id: json['id'] as String,
      section: YearReviewSection.values.firstWhere(
        (s) => s.name == json['section'],
        orElse: () => YearReviewSection.journals,
      ),
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String?,
      caption: json['caption'] as String?,
      eventDate: DateTime.tryParse(json['eventDate'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      mediaAssetId: json['mediaAssetId'] as String?,
      entityType: json['entityType'] as String?,
      entityId: json['entityId'] as String?,
      included: json['included'] as bool? ?? true,
      sortOrder: json['sortOrder'] as int? ?? 0,
      priority: json['priority'] as int? ?? 50,
      score: (json['score'] as num?)?.toDouble() ?? 0,
      checksum: json['checksum'] as String?,
    );
  }
}

@immutable
class YearReviewSectionRecommendation {
  const YearReviewSectionRecommendation({
    required this.section,
    required this.itemCount,
    required this.averageScore,
    required this.recommendEmphasize,
    required this.reasonKey,
  });

  final YearReviewSection section;
  final int itemCount;
  final double averageScore;
  final bool recommendEmphasize;
  final String reasonKey;
}

@immutable
class GrowthSummary {
  const GrowthSummary({
    this.firstHeightCm,
    this.lastHeightCm,
    this.firstWeightKg,
    this.lastWeightKg,
    this.measurementCount = 0,
  });

  final double? firstHeightCm;
  final double? lastHeightCm;
  final double? firstWeightKg;
  final double? lastWeightKg;
  final int measurementCount;

  bool get hasData => measurementCount > 0;
}

@immutable
class YearReviewDraft {
  const YearReviewDraft({
    required this.childId,
    required this.childName,
    required this.dateOfBirth,
    required this.year,
    required this.startDate,
    required this.endDate,
    required this.ageAtEnd,
    required this.items,
    this.growth = const GrowthSummary(),
    this.parentLetter,
    this.coverAssetId,
    this.theme = AlbumThemes.minimal,
    this.includeHealth = false,
    this.languageCode = 'en',
    this.titleOverride,
    this.preferenceId,
    this.suggestedTitleEn,
    this.suggestedTitleBn,
    this.sectionRecommendations = const [],
    this.collageMediaAssetIds = const [],
    this.duplicatesRemoved = 0,
  });

  final String childId;
  final String childName;
  final DateTime dateOfBirth;
  final int year;
  final DateTime startDate;
  final DateTime endDate;
  final int ageAtEnd;
  final GrowthSummary growth;
  final List<YearReviewItem> items;
  final String? parentLetter;
  final String? coverAssetId;
  final String theme;
  final bool includeHealth;
  final String languageCode;
  final String? titleOverride;
  final String? preferenceId;

  /// Smart suggested titles (applied only when parent accepts).
  final String? suggestedTitleEn;
  final String? suggestedTitleBn;
  final List<YearReviewSectionRecommendation> sectionRecommendations;
  final List<String> collageMediaAssetIds;
  final int duplicatesRemoved;

  String get displayTitle {
    final override = titleOverride?.trim();
    if (override != null && override.isNotEmpty) return override;
    return '$childName — Age $ageAtEnd: Year in Review';
  }

  String get displayTitleBn {
    final override = titleOverride?.trim();
    if (override != null && override.isNotEmpty) return override;
    return '$childName — $ageAtEnd বছর: বছরের স্মৃতিচারণ';
  }

  List<YearReviewItem> includedItems([YearReviewSection? section]) {
    final list = items.where((i) {
      if (!i.included) return false;
      if (section != null && i.section != section) return false;
      if (!includeHealth && i.section == YearReviewSection.health) {
        return false;
      }
      return true;
    }).toList()
      ..sort((a, b) {
        final bySection = a.section.index.compareTo(b.section.index);
        if (bySection != 0) return bySection;
        return a.sortOrder.compareTo(b.sortOrder);
      });
    return list;
  }

  YearReviewDraft copyWith({
    List<YearReviewItem>? items,
    String? parentLetter,
    bool clearParentLetter = false,
    String? coverAssetId,
    bool clearCoverAssetId = false,
    String? theme,
    bool? includeHealth,
    String? languageCode,
    String? titleOverride,
    bool clearTitleOverride = false,
    String? preferenceId,
    GrowthSummary? growth,
    String? suggestedTitleEn,
    String? suggestedTitleBn,
    List<YearReviewSectionRecommendation>? sectionRecommendations,
    List<String>? collageMediaAssetIds,
    int? duplicatesRemoved,
  }) {
    return YearReviewDraft(
      childId: childId,
      childName: childName,
      dateOfBirth: dateOfBirth,
      year: year,
      startDate: startDate,
      endDate: endDate,
      ageAtEnd: ageAtEnd,
      growth: growth ?? this.growth,
      items: items ?? this.items,
      parentLetter: clearParentLetter
          ? null
          : (parentLetter ?? this.parentLetter),
      coverAssetId: clearCoverAssetId
          ? null
          : (coverAssetId ?? this.coverAssetId),
      theme: theme ?? this.theme,
      includeHealth: includeHealth ?? this.includeHealth,
      languageCode: languageCode ?? this.languageCode,
      titleOverride: clearTitleOverride
          ? null
          : (titleOverride ?? this.titleOverride),
      preferenceId: preferenceId ?? this.preferenceId,
      suggestedTitleEn: suggestedTitleEn ?? this.suggestedTitleEn,
      suggestedTitleBn: suggestedTitleBn ?? this.suggestedTitleBn,
      sectionRecommendations:
          sectionRecommendations ?? this.sectionRecommendations,
      collageMediaAssetIds: collageMediaAssetIds ?? this.collageMediaAssetIds,
      duplicatesRemoved: duplicatesRemoved ?? this.duplicatesRemoved,
    );
  }

  static String encodeSelection(List<YearReviewItem> items) {
    return jsonEncode(items.map((i) => i.toJson()).toList());
  }

  static List<YearReviewItem> decodeSelection(String? raw) {
    if (raw == null || raw.isEmpty) return const [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        return decoded
            .whereType<Map>()
            .map((e) => YearReviewItem.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
    } catch (_) {}
    return const [];
  }
}

@immutable
class YearReviewPreference {
  const YearReviewPreference({
    required this.id,
    required this.childId,
    required this.year,
    required this.theme,
    required this.includeHealth,
    required this.languageCode,
    required this.createdAt,
    required this.updatedAt,
    this.parentLetter,
    this.coverAssetId,
    this.selectionJson,
    this.titleOverride,
    this.deletedAt,
  });

  final String id;
  final String childId;
  final int year;
  final String? parentLetter;
  final String? coverAssetId;
  final String theme;
  final bool includeHealth;
  final String languageCode;
  final String? selectionJson;
  final String? titleOverride;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
}

enum PdfGenerationStage {
  preparingMemories,
  processingPhotos,
  buildingPages,
  savingPdf,
  complete,
  failed,
}

@immutable
class PdfGenerationProgress {
  const PdfGenerationProgress({
    required this.stage,
    this.message,
    this.fraction = 0,
    this.error,
  });

  final PdfGenerationStage stage;
  final String? message;
  final double fraction;
  final Object? error;
}

@immutable
class GeneratedPdfResult {
  const GeneratedPdfResult({
    required this.exportId,
    required this.title,
    required this.absolutePath,
    required this.relativePath,
    required this.pageCount,
    required this.byteSize,
  });

  final String exportId;
  final String title;
  final String absolutePath;
  final String relativePath;
  final int pageCount;
  final int byteSize;
}
