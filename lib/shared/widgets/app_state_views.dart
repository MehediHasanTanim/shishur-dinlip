import 'package:flutter/material.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

/// Shared production UI states used across features.
abstract final class AppStateViews {
  static Widget loading({String? message}) {
    return Builder(
      builder: (context) {
        final l10n = AppLocalizations.of(context);
        final label = message ?? l10n.stateLoading;
        return Semantics(
          liveRegion: true,
          label: label,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(strokeWidth: 2.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static Widget skeletonList({int count = 6}) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: count,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return const _SkeletonCard();
      },
    );
  }

  static Widget empty({
    required IconData icon,
    required String title,
    String? subtitle,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        return Semantics(
          label: [title, ?subtitle].join('. '),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 56, color: theme.colorScheme.primary),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleLarge,
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                  if (actionLabel != null && onAction != null) ...[
                    const SizedBox(height: 20),
                    FilledButton(
                      onPressed: onAction,
                      child: Text(actionLabel),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static Widget migration() {
    return Builder(
      builder: (context) =>
          loading(message: AppLocalizations.of(context).stateMigration),
    );
  }

  static Widget progress({required String message, double? value}) {
    return Builder(
      builder: (context) {
        return Semantics(
          liveRegion: true,
          label: message,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 220,
                    child: LinearProgressIndicator(value: value),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static Widget error({
    String? message,
    VoidCallback? onRetry,
  }) {
    return Builder(
      builder: (context) {
        final l10n = AppLocalizations.of(context);
        final theme = Theme.of(context);
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
                const SizedBox(height: 12),
                Text(
                  message ?? l10n.errorGeneric,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge,
                ),
                if (onRetry != null) ...[
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: onRetry,
                    child: Text(l10n.commonRetry),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget permissionDenied({
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return empty(
      icon: Icons.lock_outline,
      title: message,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  static Future<bool> confirmDelete(
    BuildContext context, {
    required String title,
    required String message,
  }) async {
    final l10n = AppLocalizations.of(context);
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.commonDelete),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  static void showSaveSuccess(BuildContext context, [String? message]) {
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message ?? l10n.stateSaveSuccess)),
    );
  }

  static void showSaveFailure(BuildContext context, [String? message]) {
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message ?? l10n.stateSaveFailure),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  static void showSaveProgress(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        content: Text(l10n.stateSaveProgress),
      ),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).colorScheme.surfaceContainerHighest;
    return Semantics(
      label: AppLocalizations.of(context).stateLoading,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 16,
                width: 160,
                decoration: BoxDecoration(
                  color: base,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                height: 12,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: base.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 12,
                width: 220,
                decoration: BoxDecoration(
                  color: base.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Accessible min touch target wrapper (48×48).
class AppTouchTarget extends StatelessWidget {
  const AppTouchTarget({super.key, required this.child, this.semanticLabel});

  final Widget child;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final content = ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
      child: Center(child: child),
    );
    if (semanticLabel == null) return content;
    return Semantics(label: semanticLabel, button: true, child: content);
  }
}
