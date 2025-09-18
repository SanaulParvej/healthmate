class UserProfile {
  final String name;
  final int age;
  final double height;
  final double weight;
  final int dailyStepsGoal;
  final int dailyWaterGoal;
  final int dailySleepGoal;

  UserProfile({
    required this.name,
    required this.age,
    required this.height,
    required this.weight,
    this.dailyStepsGoal = 10000,
    this.dailyWaterGoal = 8,
    this.dailySleepGoal = 8,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'age': age,
    'height': height,
    'weight': weight,
    'dailyStepsGoal': dailyStepsGoal,
    'dailyWaterGoal': dailyWaterGoal,
    'dailySleepGoal': dailySleepGoal,
  };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    name: json['name'] ?? '',
    age: json['age'] ?? 0,
    height: json['height'] ?? 0.0,
    weight: json['weight'] ?? 0.0,
    dailyStepsGoal: json['dailyStepsGoal'] ?? 10000,
    dailyWaterGoal: json['dailyWaterGoal'] ?? 8,
    dailySleepGoal: json['dailySleepGoal'] ?? 8,
  );

  UserProfile copyWith({
    String? name,
    int? age,
    double? height,
    double? weight,
    int? dailyStepsGoal,
    int? dailyWaterGoal,
    int? dailySleepGoal,
  }) => UserProfile(
    name: name ?? this.name,
    age: age ?? this.age,
    height: height ?? this.height,
    weight: weight ?? this.weight,
    dailyStepsGoal: dailyStepsGoal ?? this.dailyStepsGoal,
    dailyWaterGoal: dailyWaterGoal ?? this.dailyWaterGoal,
    dailySleepGoal: dailySleepGoal ?? this.dailySleepGoal,
  );
}
