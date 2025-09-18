class SleepData {
  final DateTime date;
  final DateTime? bedTime;
  final DateTime? wakeTime;
  final int sleepQuality;
  final String notes;

  SleepData({
    required this.date,
    this.bedTime,
    this.wakeTime,
    this.sleepQuality = 5,
    this.notes = '',
  });

  Duration? get sleepDuration {
    if (bedTime == null || wakeTime == null) return null;

    DateTime adjustedWakeTime = wakeTime!;
    if (wakeTime!.isBefore(bedTime!)) {
      adjustedWakeTime = wakeTime!.add(const Duration(days: 1));
    }

    return adjustedWakeTime.difference(bedTime!);
  }

  double get sleepHours {
    final duration = sleepDuration;
    if (duration == null) return 0.0;
    return duration.inMinutes / 60.0;
  }

  String get sleepDurationFormatted {
    final duration = sleepDuration;
    if (duration == null) return '0h 0m';

    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    return '${hours}h ${minutes}m';
  }

  String get sleepQualityText {
    switch (sleepQuality) {
      case 1:
        return 'Very Poor';
      case 2:
        return 'Poor';
      case 3:
        return 'Fair';
      case 4:
        return 'Good';
      case 5:
        return 'Excellent';
      default:
        return 'Good';
    }
  }

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'bedTime': bedTime?.toIso8601String(),
    'wakeTime': wakeTime?.toIso8601String(),
    'sleepQuality': sleepQuality,
    'notes': notes,
  };

  factory SleepData.fromJson(Map<String, dynamic> json) => SleepData(
    date: DateTime.parse(json['date']),
    bedTime: json['bedTime'] != null ? DateTime.parse(json['bedTime']) : null,
    wakeTime: json['wakeTime'] != null
        ? DateTime.parse(json['wakeTime'])
        : null,
    sleepQuality: json['sleepQuality'] ?? 5,
    notes: json['notes'] ?? '',
  );

  SleepData copyWith({
    DateTime? date,
    DateTime? bedTime,
    DateTime? wakeTime,
    int? sleepQuality,
    String? notes,
  }) => SleepData(
    date: date ?? this.date,
    bedTime: bedTime ?? this.bedTime,
    wakeTime: wakeTime ?? this.wakeTime,
    sleepQuality: sleepQuality ?? this.sleepQuality,
    notes: notes ?? this.notes,
  );
}
