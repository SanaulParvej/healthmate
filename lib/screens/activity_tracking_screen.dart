import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/shared_widgets.dart';
import '../widgets/chart_widget.dart';
import '../utils/app_theme.dart';

class ActivityTrackingScreen extends StatefulWidget {
  const ActivityTrackingScreen({super.key});

  @override
  State<ActivityTrackingScreen> createState() => _ActivityTrackingScreenState();
}

class _ActivityTrackingScreenState extends State<ActivityTrackingScreen> {
  int currentSteps = 6500;
  double currentDistance = 4.2;
  int activeMinutes = 45;
  double caloriesBurned = 320;
  int stepsGoal = 10000;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: Theme.of(context).brightness == Brightness.light
              ? AppColors.lightGradient
              : AppColors.darkGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 24),
                _buildMainProgress(context),
                const SizedBox(height: 24),
                _buildActivityStats(context),
                const SizedBox(height: 24),
                _buildWeeklyChart(context),
                const SizedBox(height: 24),
                _buildAchievements(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Activity Tracking',
          style: Theme.of(
            context,
          ).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          DateFormat('EEEE, MMM d').format(DateTime.now()),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildMainProgress(BuildContext context) {
    final stepsProgress = (currentSteps / stepsGoal).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Daily Steps Goal',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        GlassCard(
          child: Column(
            children: [
              CircularProgressWidget(
                percentage: stepsProgress,
                centerText: NumberFormat('#,###').format(currentSteps),
                subtitle: 'of ${NumberFormat('#,###').format(stepsGoal)} steps',
                primaryColor: AppColors.primaryBlue,
                size: 120,
                strokeWidth: 10,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildMiniStat(
                    context,
                    'Remaining',
                    NumberFormat(
                      '#,###',
                    ).format((stepsGoal - currentSteps).clamp(0, stepsGoal)),
                    Icons.trending_up,
                    AppColors.primaryGreen,
                  ),
                  _buildMiniStat(
                    context,
                    'Progress',
                    '${(stepsProgress * 100).toInt()}%',
                    Icons.check_circle,
                    AppColors.primaryBlue,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMiniStat(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(title, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }

  Widget _buildActivityStats(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Today\'s Activity',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.3,
          children: [
            StatsCard(
              title: 'Distance',
              value: currentDistance.toStringAsFixed(1),
              unit: 'km',
              icon: Icons.timeline,
              color: AppColors.primaryGreen,
            ),
            StatsCard(
              title: 'Calories',
              value: caloriesBurned.toStringAsFixed(0),
              unit: 'kcal',
              icon: Icons.local_fire_department,
              color: const Color(0xFFE74C3C),
            ),
            StatsCard(
              title: 'Active Time',
              value: activeMinutes.toString(),
              unit: 'min',
              icon: Icons.timer,
              color: const Color(0xFFF39C12),
            ),
            StatsCard(
              title: 'Avg Pace',
              value: '12.5',
              unit: 'min/km',
              icon: Icons.speed,
              color: const Color(0xFF9B59B6),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWeeklyChart(BuildContext context) {
    return GlassCard(
      child: HealthChartWidget(
        title: 'Weekly Steps Progress',
        data: [
          ChartData(label: 'Mon', value: 8500),
          ChartData(label: 'Tue', value: 7200),
          ChartData(label: 'Wed', value: 9100),
          ChartData(label: 'Thu', value: 6800),
          ChartData(label: 'Fri', value: 8900),
          ChartData(label: 'Sat', value: 5400),
          ChartData(label: 'Sun', value: 6500),
        ],
        chartType: ChartType.bar,
        primaryColor: AppColors.primaryBlue,
        unit: 'steps',
      ),
    );
  }

  Widget _buildAchievements(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Achievements',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        GlassCard(
          child: Column(
            children: [
              _buildAchievementItem(
                context,
                'Daily Goal Reached',
                'Completed 10,000 steps yesterday',
                Icons.emoji_events,
                const Color(0xFFFFD700),
                true,
              ),
              const Divider(),
              _buildAchievementItem(
                context,
                '5K Distance',
                'Walked 5 kilometers today',
                Icons.directions_walk,
                AppColors.primaryGreen,
                true,
              ),
              const Divider(),
              _buildAchievementItem(
                context,
                'Week Warrior',
                '2,000 steps to complete weekly goal',
                Icons.trending_up,
                AppColors.primaryBlue,
                false,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAchievementItem(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
    bool completed,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          if (completed)
            Icon(Icons.check_circle, color: AppColors.primaryGreen, size: 20),
        ],
      ),
    );
  }
}
