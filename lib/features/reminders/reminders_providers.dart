import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/core/domain/models/reminder.dart';
import 'package:shishur_dinlipi/features/children/child_controller.dart';

final remindersListProvider = FutureProvider.autoDispose<List<Reminder>>((
  ref,
) async {
  final child = ref.watch(selectedChildProvider).valueOrNull;
  return ref.watch(remindersRepositoryProvider).list(childId: child?.id);
});

final upcomingRemindersProvider =
    FutureProvider.autoDispose<List<Reminder>>((ref) async {
      return ref.watch(remindersRepositoryProvider).upcoming(limit: 8);
    });
