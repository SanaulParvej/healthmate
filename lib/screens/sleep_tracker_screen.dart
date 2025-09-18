import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/shared_widgets.dart';
import '../widgets/chart_widget.dart';
import '../utils/app_theme.dart';

class SleepTrackerScreen extends StatefulWidget {
  const SleepTrackerScreen({super.key});

  @override
  State<SleepTrackerScreen> createState() => _SleepTrackerScreenState();
}

class _SleepTrackerScreenState extends State<SleepTrackerScreen> {
  DateTime? bedTime;
  DateTime? wakeTime;
  int sleepQuality = 4;
  String notes = '';
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    bedTime = DateTime.now().subtract(const Duration(hours: 8));
    wakeTime = DateTime.now();
    _notesController.text = notes;
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Duration? get sleepDuration {
    if (bedTime == null || wakeTime == null) return null;

    DateTime adjustedBedTime = bedTime!;
    DateTime adjustedWakeTime = wakeTime!;

    // If wake time is before bed time, it means we slept overnight
    if (wakeTime!.isBefore(bedTime!)) {
      // If bed time is in the evening (after 6 PM), wake time is next day
      if (bedTime!.hour >= 18) {
        adjustedWakeTime = wakeTime!.add(const Duration(days: 1));
      }
      // If bed time is in the morning (before 6 AM), bed time is previous day
      else if (bedTime!.hour < 6) {
        adjustedBedTime = bedTime!.subtract(const Duration(days: 1));
      }
    }

    return adjustedWakeTime.difference(adjustedBedTime);
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
                _buildSleepProgress(context),
                const SizedBox(height: 24),
                _buildTimeSelectors(context),
                const SizedBox(height: 24),
                _buildQualitySelector(context),
                const SizedBox(height: 24),
                _buildWeeklyChart(context),
                const SizedBox(height: 24),
                _buildSleepInsights(context),
                const SizedBox(height: 24),
                _buildNotesSection(context),
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
          'Sleep Tracker',
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

  Widget _buildSleepProgress(BuildContext context) {
    final sleepGoal = 8.0;
    final progress = (sleepHours / sleepGoal).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Last Night\'s Sleep',
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
                percentage: progress,
                centerText: sleepDurationFormatted,
                subtitle: 'of 8h goal',
                primaryColor: AppColors.softPurple,
                size: 120,
                strokeWidth: 10,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildMiniStat(
                    context,
                    'Bedtime',
                    bedTime != null
                        ? DateFormat('HH:mm').format(bedTime!)
                        : '--:--',
                    Icons.bedtime,
                    const Color(0xFF9B59B6),
                  ),
                  _buildMiniStat(
                    context,
                    'Wake Up',
                    wakeTime != null
                        ? DateFormat('HH:mm').format(wakeTime!)
                        : '--:--',
                    Icons.wb_sunny,
                    const Color(0xFFF39C12),
                  ),
                  _buildMiniStat(
                    context,
                    'Quality',
                    _getSleepQualityText(sleepQuality),
                    Icons.star,
                    AppColors.primaryGreen,
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
            fontSize: 14,
          ),
        ),
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildTimeSelectors(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sleep Times',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildTimeSelector(
                  context,
                  'Bedtime',
                  bedTime,
                  Icons.bedtime,
                  const Color(0xFF9B59B6),
                  (time) => setState(() => bedTime = time),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTimeSelector(
                  context,
                  'Wake Up',
                  wakeTime,
                  Icons.wb_sunny,
                  const Color(0xFFF39C12),
                  (time) => setState(() => wakeTime = time),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSelector(
    BuildContext context,
    String title,
    DateTime? time,
    IconData icon,
    Color color,
    Function(DateTime) onTimeSelected,
  ) {
    return GestureDetector(
      onTap: () async {
        final TimeOfDay? selectedTime = await showTimePicker(
          context: context,
          initialTime: time != null
              ? TimeOfDay.fromDateTime(time)
              : TimeOfDay.now(),
        );

        if (selectedTime != null) {
          final now = DateTime.now();
          final selectedDateTime = DateTime(
            now.year,
            now.month,
            now.day,
            selectedTime.hour,
            selectedTime.minute,
          );
          onTimeSelected(selectedDateTime);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              time != null ? DateFormat('HH:mm').format(time) : '--:--',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: color,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQualitySelector(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sleep Quality',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(5, (index) {
              final quality = index + 1;
              final isSelected = sleepQuality == quality;

              return GestureDetector(
                onTap: () => setState(() => sleepQuality = quality),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryGreen
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryGreen
                          : AppColors.mediumGray,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.star,
                    color: isSelected ? Colors.white : AppColors.mediumGray,
                    size: 24,
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              _getSleepQualityText(sleepQuality),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.primaryGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyChart(BuildContext context) {
    return GlassCard(
      child: HealthChartWidget(
        title: 'Weekly Sleep Hours',
        data: [
          ChartData(label: 'Mon', value: 7.5),
          ChartData(label: 'Tue', value: 8.2),
          ChartData(label: 'Wed', value: 6.8),
          ChartData(label: 'Thu', value: 8.0),
          ChartData(label: 'Fri', value: 7.2),
          ChartData(label: 'Sat', value: 9.1),
          ChartData(label: 'Sun', value: sleepHours),
        ],
        chartType: ChartType.line,
        primaryColor: AppColors.softPurple,
        unit: 'hours',
      ),
    );
  }

  Widget _buildSleepInsights(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sleep Insights',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          _buildInsightItem(
            context,
            'Average Sleep',
            '7.4 hours this week',
            Icons.trending_up,
            AppColors.primaryGreen,
          ),
          _buildInsightItem(
            context,
            'Best Sleep Day',
            'Saturday (9.1 hours)',
            Icons.emoji_events,
            const Color(0xFFFFD700),
          ),
          _buildInsightItem(
            context,
            'Recommendation',
            'Try to sleep before 11 PM',
            Icons.lightbulb,
            AppColors.primaryBlue,
          ),
        ],
      ),
    );
  }

  Widget _buildInsightItem(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
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
                Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesSection(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sleep Notes',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _notesController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'How did you sleep? Any observations?',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppColors.mediumGray.withValues(alpha: 0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primaryBlue),
              ),
            ),
            onChanged: (value) => notes = value,
          ),
        ],
      ),
    );
  }

  String _getSleepQualityText(int quality) {
    switch (quality) {
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
}
