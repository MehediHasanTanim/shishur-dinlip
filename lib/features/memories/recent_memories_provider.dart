import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/core/domain/entity_types.dart';
import 'package:shishur_dinlipi/core/domain/models/attachment.dart';
import 'package:shishur_dinlipi/core/files/file_storage_service.dart';
import 'package:shishur_dinlipi/features/children/child_controller.dart';

enum RecentMemoryKind { journal, funny, achievement }

@immutable
class RecentMemoryCard {
  const RecentMemoryCard({
    required this.kind,
    required this.id,
    required this.title,
    required this.eventDate,
    this.subtitle,
    this.thumbnail,
  });

  final RecentMemoryKind kind;
  final String id;
  final String title;
  final DateTime eventDate;
  final String? subtitle;
  final File? thumbnail;
}

final recentMemoriesProvider =
    FutureProvider.autoDispose<List<RecentMemoryCard>>((ref) async {
      final childAsync = ref.watch(selectedChildProvider);
      final child = childAsync.valueOrNull;
      if (child == null) return const [];

      final journals = await ref
          .read(journalRepositoryProvider)
          .forChild(child.id, limit: 3);
      final funny = await ref
          .read(funnyMomentsRepositoryProvider)
          .forChild(child.id, limit: 2);
      final achievements = await ref
          .read(achievementsRepositoryProvider)
          .forChild(child.id, limit: 2);
      final attachments = ref.read(attachmentRepositoryProvider);
      final storage = ref.read(fileStorageServiceProvider);

      Future<File?> thumb(String entityType, String entityId) async {
        final list = await attachments.forEntity(
          entityType: entityType,
          entityId: entityId,
        );
        return firstAttachmentThumb(list, storage);
      }

      final cards = <RecentMemoryCard>[];

      for (final j in journals) {
        cards.add(
          RecentMemoryCard(
            kind: RecentMemoryKind.journal,
            id: j.id,
            title: j.displayTitle,
            eventDate: j.eventDate,
            subtitle: j.mood,
            thumbnail: await thumb(EntityTypes.journalEntry, j.id),
          ),
        );
      }
      for (final f in funny) {
        cards.add(
          RecentMemoryCard(
            kind: RecentMemoryKind.funny,
            id: f.id,
            title: f.displayTitle,
            eventDate: f.eventDate,
            subtitle: f.quoteText,
            thumbnail: await thumb(EntityTypes.funnyMoment, f.id),
          ),
        );
      }
      for (final a in achievements) {
        cards.add(
          RecentMemoryCard(
            kind: RecentMemoryKind.achievement,
            id: a.id,
            title: a.title,
            eventDate: a.eventDate,
            subtitle: a.category,
            thumbnail: await thumb(EntityTypes.achievement, a.id),
          ),
        );
      }

      cards.sort((a, b) => b.eventDate.compareTo(a.eventDate));
      return cards.take(6).toList();
    });

Future<File?> firstAttachmentThumb(
  List<Attachment> list,
  FileStorageService storage,
) async {
  if (list.isEmpty) return null;
  final media = list.first.media;
  if (media == null) return null;
  final path = media.thumbnailPath ?? media.localPath;
  final file = await storage.absoluteFile(path);
  if (!await file.exists()) return null;
  return file;
}
