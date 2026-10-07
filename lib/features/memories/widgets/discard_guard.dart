import 'package:flutter/material.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

Future<bool> confirmDiscardIfDirty(
  BuildContext context, {
  required bool isDirty,
}) async {
  if (!isDirty) return true;
  final l10n = AppLocalizations.of(context);
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.discardDraftTitle),
      content: Text(l10n.discardDraftMessage),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(l10n.commonKeepEditing),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(l10n.commonDiscard),
        ),
      ],
    ),
  );
  return result == true;
}
