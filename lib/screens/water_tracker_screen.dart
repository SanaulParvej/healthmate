import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/shared_widgets.dart';
import '../widgets/chart_widget.dart';
import '../utils/app_theme.dart';

class WaterTrackerScreen extends StatefulWidget {
  const WaterTrackerScreen({super.key});

  @override
  State<WaterTrackerScreen> createState() => _WaterTrackerScreenState();
}

class _WaterTrackerScreenState extends State<WaterTrackerScreen>
    with TickerProviderStateMixin {
  int currentGlasses = 6;
  int dailyGoal = 8;
  late AnimationController _waveController;
  late AnimationController _rippleController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    _rippleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _waveController.dispose();
    _rippleController.dispose();
    super.dispose();
  }

  void _addWater() {
    setState(() {
      if (currentGlasses < dailyGoal + 5) {
        currentGlasses++;
      }
    });
    _rippleController.forward().then((_) {
      _rippleController.reset();
    });
  }

  void _removeWater() {
    setState(() {
      if (currentGlasses > 0) {
        currentGlasses--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final progress = (currentGlasses / dailyGoal).clamp(0.0, 1.0);

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
                _buildWaterProgress(context, progress),
                const SizedBox(height: 24),
                _buildWaterControls(context),
                const SizedBox(height: 24),
                _buildDailyStats(context),
                const SizedBox(height: 24),
                _buildWeeklyChart(context),
                const SizedBox(height: 24),
                _buildHydrationTips(context),
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
          'Water Tracker',
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

  Widget _buildWaterProgress(BuildContext context, double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Daily Hydration Goal',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        GlassCard(
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedBuilder(
                animation: _rippleController,
                builder: (context, child) {
                  return Container(
                    width: 200 + (_rippleController.value * 20),
                    height: 200 + (_rippleController.value * 20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primaryBlue.withValues(
                          alpha: 0.3 * (1 - _rippleController.value),
                        ),
                        width: 2,
                      ),
                    ),
                  );
                },
              ),
              CircularProgressWidget(
                percentage: progress,
                centerText: '$currentGlasses/$dailyGoal',
                subtitle: 'glasses',
                primaryColor: AppColors.primaryBlue,
                size: 160,
                strokeWidth: 15,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        GlassCard(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildMiniStat(
                context,
                'Remaining',
                '${(dailyGoal - currentGlasses).clamp(0, dailyGoal)}',
                Icons.water_drop,
                AppColors.primaryBlue,
              ),
              _buildMiniStat(
                context,
                'Progress',
                '${(progress * 100).toInt()}%',
                Icons.trending_up,
                AppColors.primaryGreen,
              ),
              _buildMiniStat(
                context,
                'Volume',
                '${(currentGlasses * 250)}ml',
                Icons.local_drink,
                const Color(0xFF3498DB),
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
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildWaterControls(BuildContext context) {
    return GlassCard(
      child: Column(
        children: [
          Text(
            'Quick Add',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildWaterButton(
                context,
                '1 Glass',
                '250ml',
                Icons.water_drop,
                () => _addWater(),
              ),
              _buildWaterButton(
                context,
                '1 Bottle',
                '500ml',
                Icons.local_drink,
                () {
                  setState(() {
                    currentGlasses += 2;
                  });
                },
              ),
              _buildWaterButton(
                context,
                '1 Liter',
                '1000ml',
                Icons.sports_bar,
                () {
                  setState(() {
                    currentGlasses += 4;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: 'Add Water',
                  icon: Icons.add,
                  onPressed: _addWater,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomButton(
                  text: 'Remove',
                  icon: Icons.remove,
                  backgroundColor: Colors.red.withValues(alpha: 0.8),
                  onPressed: _removeWater,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWaterButton(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: AppColors.primaryBlue.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.primaryBlue.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.primaryBlue, size: 24),
            const SizedBox(height: 2),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 8,
                color: AppColors.mediumGray,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyStats(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: StatsCard(
            title: 'Today\'s Intake',
            value: '${currentGlasses * 250}',
            unit: 'ml',
            icon: Icons.local_drink,
            color: AppColors.primaryBlue,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: StatsCard(
            title: 'Goal Progress',
            value: '${((currentGlasses / dailyGoal) * 100).toInt()}',
            unit: '%',
            icon: Icons.emoji_events,
            color: AppColors.primaryGreen,
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklyChart(BuildContext context) {
    return GlassCard(
      child: HealthChartWidget(
        title: 'Weekly Water Intake',
        data: [
          ChartData(label: 'Mon', value: 7),
          ChartData(label: 'Tue', value: 8),
          ChartData(label: 'Wed', value: 6),
          ChartData(label: 'Thu', value: 9),
          ChartData(label: 'Fri', value: 8),
          ChartData(label: 'Sat', value: 5),
          ChartData(label: 'Sun', value: 6),
        ],
        chartType: ChartType.bar,
        primaryColor: AppColors.primaryBlue,
        unit: 'glasses',
      ),
    );
  }

  Widget _buildHydrationTips(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hydration Tips',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          _buildTipItem(
            context,
            'Start your day with a glass of water',
            Icons.wb_sunny,
            const Color(0xFFF39C12),
          ),
          _buildTipItem(
            context,
            'Drink water before meals',
            Icons.restaurant,
            AppColors.primaryGreen,
          ),
          _buildTipItem(
            context,
            'Set reminders throughout the day',
            Icons.alarm,
            AppColors.primaryBlue,
          ),
        ],
      ),
    );
  }

  Widget _buildTipItem(
    BuildContext context,
    String tip,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(tip, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
