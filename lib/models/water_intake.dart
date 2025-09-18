class WaterIntake {
  final DateTime date;
  final List<WaterEntry> entries;
  final int dailyGoal;

  WaterIntake({
    required this.date,
    this.entries = const [],
    this.dailyGoal = 8,
  });

  int get totalGlasses => entries.length;
  double get progressPercentage => (totalGlasses / dailyGoal).clamp(0.0, 1.0);
  bool get goalReached => totalGlasses >= dailyGoal;

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'entries': entries.map((e) => e.toJson()).toList(),
    'dailyGoal': dailyGoal,
  };

  factory WaterIntake.fromJson(Map<String, dynamic> json) => WaterIntake(
    date: DateTime.parse(json['date']),
    entries:
        (json['entries'] as List<dynamic>?)
            ?.map((e) => WaterEntry.fromJson(e))
            .toList() ??
        [],
    dailyGoal: json['dailyGoal'] ?? 8,
  );

  WaterIntake copyWith({
    DateTime? date,
    List<WaterEntry>? entries,
    int? dailyGoal,
  }) => WaterIntake(
    date: date ?? this.date,
    entries: entries ?? this.entries,
    dailyGoal: dailyGoal ?? this.dailyGoal,
  );

  WaterIntake addEntry(WaterEntry entry) {
    final newEntries = List<WaterEntry>.from(entries)..add(entry);
    return copyWith(entries: newEntries);
  }

  WaterIntake removeLastEntry() {
    if (entries.isEmpty) return this;
    final newEntries = List<WaterEntry>.from(entries)..removeLast();
    return copyWith(entries: newEntries);
  }
}

class WaterEntry {
  final DateTime timestamp;
  final int glasses;

  WaterEntry({required this.timestamp, this.glasses = 1});

  Map<String, dynamic> toJson() => {
    'timestamp': timestamp.toIso8601String(),
    'glasses': glasses,
  };

  factory WaterEntry.fromJson(Map<String, dynamic> json) => WaterEntry(
    timestamp: DateTime.parse(json['timestamp']),
    glasses: json['glasses'] ?? 1,
  );
}
