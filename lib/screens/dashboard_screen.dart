import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/shared_widgets.dart';
import '../widgets/chart_widget.dart';
import '../utils/app_theme.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final formattedDate = DateFormat('EEEE, MMM d').format(today);

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
                _buildHeader(context, formattedDate),
                const SizedBox(height: 24),
                _buildDailyOverview(context),
                const SizedBox(height: 24),
                _buildStatsGrid(context),
                const SizedBox(height: 24),
                _buildActivityChart(context),
                const SizedBox(height: 24),
                _buildQuickActions(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String formattedDate) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hello, Sir!',
          style: Theme.of(
            context,
          ).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(formattedDate, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }

  Widget _buildDailyOverview(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Today\'s Progress',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        GlassCard(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircularProgressWidget(
                percentage: 0.65,
                centerText: '6,500',
                subtitle: 'Steps',
                primaryColor: AppColors.primaryBlue,
                size: 70,
              ),
              CircularProgressWidget(
                percentage: 0.8,
                centerText: '6/8',
                subtitle: 'Water',
                primaryColor: AppColors.primaryGreen,
                size: 70,
              ),
              CircularProgressWidget(
                percentage: 0.9,
                centerText: '7.2h',
                subtitle: 'Sleep',
                primaryColor: AppColors.softPurple,
                size: 70,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.3,
      children: [
        StatsCard(
          title: 'Steps',
          value: '6,500',
          unit: 'steps',
          icon: Icons.directions_walk,
          color: AppColors.primaryBlue,
        ),
        StatsCard(
          title: 'Distance',
          value: '4.2',
          unit: 'km',
          icon: Icons.timeline,
          color: AppColors.primaryGreen,
        ),
        StatsCard(
          title: 'Calories',
          value: '320',
          unit: 'kcal',
          icon: Icons.local_fire_department,
          color: const Color(0xFFE74C3C),
        ),
        StatsCard(
          title: 'Active Time',
          value: '45',
          unit: 'min',
          icon: Icons.timer,
          color: const Color(0xFFF39C12),
        ),
      ],
    );
  }

  Widget _buildActivityChart(BuildContext context) {
    return GlassCard(
      child: HealthChartWidget(
        title: 'Weekly Steps',
        data: [
          ChartData(label: 'Mon', value: 7500),
          ChartData(label: 'Tue', value: 8200),
          ChartData(label: 'Wed', value: 6800),
          ChartData(label: 'Thu', value: 9500),
          ChartData(label: 'Fri', value: 5200),
          ChartData(label: 'Sat', value: 10800),
          ChartData(label: 'Sun', value: 7300),
        ],
        chartType: ChartType.line,
        primaryColor: AppColors.primaryBlue,
        unit: 'steps',
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: CustomButton(
                text: 'Log Water',
                icon: Icons.water_drop,
                onPressed: () {
                  // TODO: Navigate to water tracker
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomButton(
                text: 'Log Sleep',
                icon: Icons.bedtime,
                backgroundColor: AppColors.softPurple,
                onPressed: () {
                  // TODO: Navigate to sleep tracker
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        CustomButton(
          text: 'Start Workout',
          icon: Icons.play_arrow,
          backgroundColor: AppColors.primaryGreen,
          width: double.infinity,
          onPressed: () {
            // TODO: Navigate to activity tracker
          },
        ),
      ],
    );
  }
}
