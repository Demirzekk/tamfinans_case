class AppConfig {
  AppConfig._();

  static DateTime get defaultDate {
    final now = DateTime.now();

    final knownWorkingDate = DateTime(2026, 1, 17);

    if (now.year > 2026 ||
        (now.year == 2026 && now.isAfter(knownWorkingDate))) {
      return knownWorkingDate;
    }

    if (now.weekday == DateTime.saturday) {
      return now.subtract(const Duration(days: 1)); // Cuma
    } else if (now.weekday == DateTime.sunday) {
      return now.subtract(const Duration(days: 2)); // Cuma
    }

    return now;
  }
}
