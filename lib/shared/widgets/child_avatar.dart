import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/core/domain/models/child.dart';

class ChildAvatar extends ConsumerWidget {
  const ChildAvatar({
    super.key,
    required this.child,
    this.radius = 28,
  });

  final Child child;
  final double radius;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return FutureBuilder<File?>(
      future: ref
          .read(profilePhotoServiceProvider)
          .resolvePhotoFile(child.profilePhotoId),
      builder: (context, snapshot) {
        final file = snapshot.data;
        return CircleAvatar(
          radius: radius,
          backgroundColor: theme.colorScheme.primaryContainer,
          backgroundImage: file == null ? null : FileImage(file),
          child: file == null
              ? Text(
                  _initials(child.displayName),
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w700,
                  ),
                )
              : null,
        );
      },
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first.characters.first.toUpperCase();
    return (parts.first.characters.first + parts.last.characters.first)
        .toUpperCase();
  }
}
