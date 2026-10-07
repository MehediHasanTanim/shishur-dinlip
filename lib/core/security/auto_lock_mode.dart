enum AutoLockMode {
  immediately,
  oneMinute,
  fiveMinutes,
  fifteenMinutes;

  Duration? get timeout {
    return switch (this) {
      AutoLockMode.immediately => Duration.zero,
      AutoLockMode.oneMinute => const Duration(minutes: 1),
      AutoLockMode.fiveMinutes => const Duration(minutes: 5),
      AutoLockMode.fifteenMinutes => const Duration(minutes: 15),
    };
  }

  static AutoLockMode fromStorage(String? value) {
    return AutoLockMode.values.firstWhere(
      (m) => m.name == value,
      orElse: () => AutoLockMode.immediately,
    );
  }
}
