import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';

/// Runs [RemindersRepository.rescheduleAll] once after the first frame.
class ReminderBootstrap extends ConsumerStatefulWidget {
  const ReminderBootstrap({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<ReminderBootstrap> createState() => _ReminderBootstrapState();
}

class _ReminderBootstrapState extends ConsumerState<ReminderBootstrap> {
  var _started = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _reschedule());
  }

  Future<void> _reschedule() async {
    if (_started) return;
    _started = true;
    try {
      await ref.read(remindersRepositoryProvider).rescheduleAll();
    } catch (_) {
      // Non-fatal: notifications may be unavailable before permissions.
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
