import 'package:flutter/material.dart';
import 'package:shishur_dinlipi/core/audio/first_word_audio_controller.dart';
import 'package:shishur_dinlipi/core/errors/error_mapper.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

/// Record / play / delete controls for a first-word audio clip.
class FirstWordAudioPanel extends StatefulWidget {
  const FirstWordAudioPanel({
    super.key,
    required this.controller,
    this.readOnly = false,
    this.onChanged,
  });

  final FirstWordAudioController controller;
  final bool readOnly;
  final VoidCallback? onChanged;

  @override
  State<FirstWordAudioPanel> createState() => _FirstWordAudioPanelState();
}

class _FirstWordAudioPanelState extends State<FirstWordAudioPanel> {
  @override
  void initState() {
    super.initState();
    widget.controller.onChanged = _refresh;
  }

  @override
  void didUpdateWidget(covariant FirstWordAudioPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.onChanged = null;
      widget.controller.onChanged = _refresh;
    }
  }

  @override
  void dispose() {
    widget.controller.onChanged = null;
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
    widget.onChanged?.call();
  }

  Future<void> _run(Future<void> Function() action) async {
    try {
      await action();
    } catch (error) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context);
      final message = ErrorMapper.localize(context, error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message == l10n.errorPermission
                ? l10n.firstWordMicDenied
                : message,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = widget.controller;
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                c.isRecording
                    ? Icons.mic
                    : (c.hasAudio ? Icons.graphic_eq : Icons.mic_none),
                color: c.isRecording
                    ? theme.colorScheme.error
                    : theme.colorScheme.primary,
              ),
              title: Text(l10n.firstWordAudioTitle),
              subtitle: Text(
                c.isRecording
                    ? l10n.firstWordRecording
                    : (c.hasAudio
                          ? l10n.firstWordAudioReady
                          : l10n.firstWordAudioEmpty),
              ),
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (!widget.readOnly) ...[
                  if (!c.isRecording)
                    FilledButton.tonalIcon(
                      onPressed: () => _run(c.startRecording),
                      icon: const Icon(Icons.fiber_manual_record),
                      label: Text(
                        c.hasAudio
                            ? l10n.firstWordReRecord
                            : l10n.firstWordRecord,
                      ),
                    )
                  else
                    FilledButton.icon(
                      onPressed: () => _run(c.stopRecording),
                      icon: const Icon(Icons.stop),
                      label: Text(l10n.firstWordStopRecording),
                    ),
                ],
                if (c.hasAudio && !c.isRecording) ...[
                  OutlinedButton.icon(
                    onPressed: () => _run(
                      c.isPlaying ? c.stopPlayback : c.play,
                    ),
                    icon: Icon(
                      c.isPlaying ? Icons.stop_circle_outlined : Icons.play_arrow,
                    ),
                    label: Text(
                      c.isPlaying ? l10n.firstWordStopPlayback : l10n.firstWordPlay,
                    ),
                  ),
                  if (!widget.readOnly)
                    TextButton.icon(
                      onPressed: () => _run(
                        () => c.clearAudio(deleteSavedAsset: true),
                      ),
                      icon: const Icon(Icons.delete_outline),
                      label: Text(l10n.firstWordDeleteAudio),
                    ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
