import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';
import '../models/daily_activity.dart';
import '../models/water_intake.dart';
import '../models/sleep_data.dart';

class HealthDataService {
  static const String _userProfileKey = 'user_profile';
  static const String _dailyActivitiesKey = 'daily_activities';
  static const String _waterIntakeKey = 'water_intake';
  static const String _sleepDataKey = 'sleep_data';

  Future<UserProfile?> getUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final String? profileJson = prefs.getString(_userProfileKey);

    if (profileJson != null) {
      final Map<String, dynamic> profileMap = json.decode(profileJson);
      return UserProfile.fromJson(profileMap);
    }

    return null;
  }

  Future<void> saveUserProfile(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    final String profileJson = json.encode(profile.toJson());
    await prefs.setString(_userProfileKey, profileJson);
  }

  Future<List<DailyActivity>> getDailyActivities() async {
    final prefs = await SharedPreferences.getInstance();
    final String? activitiesJson = prefs.getString(_dailyActivitiesKey);

    if (activitiesJson != null) {
      final List<dynamic> activitiesList = json.decode(activitiesJson);
      return activitiesList
          .map((activity) => DailyActivity.fromJson(activity))
          .toList();
    }

    return [];
  }

  Future<void> saveDailyActivity(DailyActivity activity) async {
    final activities = await getDailyActivities();

    final existingIndex = activities.indexWhere(
      (a) => _isSameDay(a.date, activity.date),
    );

    if (existingIndex != -1) {
      activities[existingIndex] = activity;
    } else {
      activities.add(activity);
    }

    activities.sort((a, b) => b.date.compareTo(a.date));

    if (activities.length > 30) {
      activities.removeRange(30, activities.length);
    }

    final prefs = await SharedPreferences.getInstance();
    final String activitiesJson = json.encode(
      activities.map((activity) => activity.toJson()).toList(),
    );
    await prefs.setString(_dailyActivitiesKey, activitiesJson);
  }

  Future<List<WaterIntake>> getWaterIntakes() async {
    final prefs = await SharedPreferences.getInstance();
    final String? waterJson = prefs.getString(_waterIntakeKey);

    if (waterJson != null) {
      final List<dynamic> waterList = json.decode(waterJson);
      return waterList.map((water) => WaterIntake.fromJson(water)).toList();
    }

    return [];
  }

  Future<void> saveWaterIntake(WaterIntake waterIntake) async {
    final waterIntakes = await getWaterIntakes();

    final existingIndex = waterIntakes.indexWhere(
      (w) => _isSameDay(w.date, waterIntake.date),
    );

    if (existingIndex != -1) {
      waterIntakes[existingIndex] = waterIntake;
    } else {
      waterIntakes.add(waterIntake);
    }

    waterIntakes.sort((a, b) => b.date.compareTo(a.date));

    if (waterIntakes.length > 30) {
      waterIntakes.removeRange(30, waterIntakes.length);
    }

    final prefs = await SharedPreferences.getInstance();
    final String waterJson = json.encode(
      waterIntakes.map((water) => water.toJson()).toList(),
    );
    await prefs.setString(_waterIntakeKey, waterJson);
  }

  Future<List<SleepData>> getSleepData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? sleepJson = prefs.getString(_sleepDataKey);

    if (sleepJson != null) {
      final List<dynamic> sleepList = json.decode(sleepJson);
      return sleepList.map((sleep) => SleepData.fromJson(sleep)).toList();
    }

    return [];
  }

  Future<void> saveSleepData(SleepData sleepData) async {
    final sleepDataList = await getSleepData();

    final existingIndex = sleepDataList.indexWhere(
      (s) => _isSameDay(s.date, sleepData.date),
    );

    if (existingIndex != -1) {
      sleepDataList[existingIndex] = sleepData;
    } else {
      sleepDataList.add(sleepData);
    }

    sleepDataList.sort((a, b) => b.date.compareTo(a.date));

    if (sleepDataList.length > 30) {
      sleepDataList.removeRange(30, sleepDataList.length);
    }

    final prefs = await SharedPreferences.getInstance();
    final String sleepJson = json.encode(
      sleepDataList.map((sleep) => sleep.toJson()).toList(),
    );
    await prefs.setString(_sleepDataKey, sleepJson);
  }

  Future<WaterIntake?> getTodayWaterIntake() async {
    final waterIntakes = await getWaterIntakes();
    final today = DateTime.now();

    try {
      return waterIntakes.firstWhere((w) => _isSameDay(w.date, today));
    } catch (e) {
      return null;
    }
  }

  Future<DailyActivity?> getTodayActivity() async {
    final activities = await getDailyActivities();
    final today = DateTime.now();

    try {
      return activities.firstWhere((a) => _isSameDay(a.date, today));
    } catch (e) {
      return null;
    }
  }

  Future<SleepData?> getLastNightSleep() async {
    final sleepDataList = await getSleepData();
    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));

    try {
      return sleepDataList.firstWhere(
        (s) => _isSameDay(s.date, yesterday) || _isSameDay(s.date, today),
      );
    } catch (e) {
      return null;
    }
  }

  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userProfileKey);
    await prefs.remove(_dailyActivitiesKey);
    await prefs.remove(_waterIntakeKey);
    await prefs.remove(_sleepDataKey);
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  Future<Map<String, dynamic>> getWeeklyStats() async {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));

    final activities = await getDailyActivities();
    final waterIntakes = await getWaterIntakes();
    final sleepData = await getSleepData();

    double totalSteps = 0;
    double totalWater = 0;
    double totalSleep = 0;
    int daysWithData = 0;

    for (int i = 0; i < 7; i++) {
      final day = weekStart.add(Duration(days: i));

      final dayActivity = activities
          .where((a) => _isSameDay(a.date, day))
          .firstOrNull;
      final dayWater = waterIntakes
          .where((w) => _isSameDay(w.date, day))
          .firstOrNull;
      final daySleep = sleepData
          .where((s) => _isSameDay(s.date, day))
          .firstOrNull;

      if (dayActivity != null) {
        totalSteps += dayActivity.steps;
        daysWithData++;
      }

      if (dayWater != null) {
        totalWater += dayWater.totalGlasses;
      }

      if (daySleep != null) {
        totalSleep += daySleep.sleepHours;
      }
    }

    return {
      'averageSteps': daysWithData > 0
          ? (totalSteps / daysWithData).round()
          : 0,
      'averageWater': (totalWater / 7).toStringAsFixed(1),
      'averageSleep': (totalSleep / 7).toStringAsFixed(1),
      'daysWithData': daysWithData,
    };
  }
}

extension IterableExtension<T> on Iterable<T> {
  T? get firstOrNull {
    final iterator = this.iterator;
    if (iterator.moveNext()) {
      return iterator.current;
    }
    return null;
  }
}
