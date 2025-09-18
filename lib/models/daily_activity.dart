class DailyActivity {
  final DateTime date;
  final int steps;
  final double distance;
  final int activeMinutes;
  final double caloriesBurned;

  DailyActivity({
    required this.date,
    this.steps = 0,
    this.distance = 0.0,
    this.activeMinutes = 0,
    this.caloriesBurned = 0.0,
  });

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'steps': steps,
    'distance': distance,
    'activeMinutes': activeMinutes,
    'caloriesBurned': caloriesBurned,
  };

  factory DailyActivity.fromJson(Map<String, dynamic> json) => DailyActivity(
    date: DateTime.parse(json['date']),
    steps: json['steps'] ?? 0,
    distance: json['distance'] ?? 0.0,
    activeMinutes: json['activeMinutes'] ?? 0,
    caloriesBurned: json['caloriesBurned'] ?? 0.0,
  );

  DailyActivity copyWith({
    DateTime? date,
    int? steps,
    double? distance,
    int? activeMinutes,
    double? caloriesBurned,
  }) => DailyActivity(
    date: date ?? this.date,
    steps: steps ?? this.steps,
    distance: distance ?? this.distance,
    activeMinutes: activeMinutes ?? this.activeMinutes,
    caloriesBurned: caloriesBurned ?? this.caloriesBurned,
  );

  double get distanceInKm => distance / 1000;

  double calculateCalories(double weight) {
    return (steps * 0.04 * weight / 70).roundToDouble();
  }
}
