import 'package:flutter/foundation.dart';

@immutable
class Reminder {
  const Reminder({
    required this.id,
    required this.reminderType,
    required this.scheduledAt,
    required this.createdAt,
    required this.updatedAt,
    this.childId,
    this.entityType,
    this.entityId,
    this.title,
    this.notes,
    this.repeatRule,
    this.notificationId,
    this.isEnabled = true,
    this.deletedAt,
  });

  final String id;
  final String? childId;
  final String? entityType;
  final String? entityId;
  final String reminderType;
  final String? title;
  final String? notes;
  final DateTime scheduledAt;
  final String? repeatRule;
  final int? notificationId;
  final bool isEnabled;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  Reminder copyWith({
    String? id,
    String? childId,
    bool clearChildId = false,
    String? entityType,
    bool clearEntityType = false,
    String? entityId,
    bool clearEntityId = false,
    String? reminderType,
    String? title,
    bool clearTitle = false,
    String? notes,
    bool clearNotes = false,
    DateTime? scheduledAt,
    String? repeatRule,
    bool clearRepeatRule = false,
    int? notificationId,
    bool clearNotificationId = false,
    bool? isEnabled,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    bool clearDeletedAt = false,
  }) {
    return Reminder(
      id: id ?? this.id,
      childId: clearChildId ? null : (childId ?? this.childId),
      entityType: clearEntityType ? null : (entityType ?? this.entityType),
      entityId: clearEntityId ? null : (entityId ?? this.entityId),
      reminderType: reminderType ?? this.reminderType,
      title: clearTitle ? null : (title ?? this.title),
      notes: clearNotes ? null : (notes ?? this.notes),
      scheduledAt: scheduledAt ?? this.scheduledAt,
      repeatRule: clearRepeatRule ? null : (repeatRule ?? this.repeatRule),
      notificationId: clearNotificationId
          ? null
          : (notificationId ?? this.notificationId),
      isEnabled: isEnabled ?? this.isEnabled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: clearDeletedAt ? null : (deletedAt ?? this.deletedAt),
    );
  }

  String get displayTitle {
    final t = title?.trim();
    if (t != null && t.isNotEmpty) return t;
    return reminderType;
  }
}

abstract final class ReminderTypes {
  static const vaccination = 'vaccination';
  static const medicine = 'medicine';
  static const doctorFollowUp = 'doctor_follow_up';
  static const birthday = 'birthday';
  static const weeklyMemory = 'weekly_memory';
  static const backup = 'backup';
  static const custom = 'custom';

  static const all = [
    vaccination,
    medicine,
    doctorFollowUp,
    birthday,
    weeklyMemory,
    backup,
    custom,
  ];
}

abstract final class ReminderRepeatRules {
  static const none = 'none';
  static const daily = 'daily';
  static const weekly = 'weekly';
  static const yearly = 'yearly';
  static const monthly = 'monthly';
}
