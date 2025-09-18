import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../utils/app_theme.dart';

class HealthChartWidget extends StatefulWidget {
  final List<ChartData> data;
  final String title;
  final ChartType chartType;
  final Color primaryColor;
  final String unit;

  const HealthChartWidget({
    super.key,
    required this.data,
    required this.title,
    this.chartType = ChartType.line,
    this.primaryColor = AppColors.primaryBlue,
    this.unit = '',
  });

  @override
  State<HealthChartWidget> createState() => _HealthChartWidgetState();
}

class _HealthChartWidgetState extends State<HealthChartWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: FadeTransition(
              opacity: _animation,
              child: widget.chartType == ChartType.line
                  ? _buildLineChart(context)
                  : _buildBarChart(context),
            ),
          ),
        ],
      ),
    );
  }

  FlTitlesData _buildTitlesData(BuildContext context) {
    return FlTitlesData(
      show: true,
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          interval: 1,
          getTitlesWidget: (double value, TitleMeta meta) {
            if (value.toInt() >= 0 && value.toInt() < widget.data.length) {
              return SideTitleWidget(
                axisSide: meta.axisSide,
                child: Text(
                  widget.data[value.toInt()].label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }
            return const Text('');
          },
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: 1,
          getTitlesWidget: (double value, TitleMeta meta) {
            return Text(
              value.toInt().toString(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            );
          },
          reservedSize: 42,
        ),
      ),
    );
  }

  FlGridData _buildGridData(BuildContext context) {
    return FlGridData(
      show: true,
      drawVerticalLine: false,
      drawHorizontalLine: true,
      horizontalInterval: 1,
      getDrawingHorizontalLine: (value) {
        return FlLine(
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.grey.withValues(alpha: 0.3)
              : Colors.white.withValues(alpha: 0.1),
          strokeWidth: 1,
        );
      },
    );
  }

  Widget _buildLineChart(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: _buildGridData(context),
        titlesData: _buildTitlesData(context),
        borderData: FlBorderData(
          show: true,
          border: Border.all(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.grey.withValues(alpha: 0.3)
                : Colors.white.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        minX: 0,
        maxX: (widget.data.length - 1).toDouble(),
        minY: 0,
        maxY:
            widget.data.map((e) => e.value).reduce((a, b) => a > b ? a : b) *
            1.2,
        lineBarsData: [
          LineChartBarData(
            spots: widget.data
                .asMap()
                .entries
                .map((e) => FlSpot(e.key.toDouble(), e.value.value))
                .toList(),
            isCurved: true,
            gradient: LinearGradient(
              colors: [
                widget.primaryColor.withValues(alpha: 0.8),
                widget.primaryColor.withValues(alpha: 0.5),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 6,
                  color: widget.primaryColor,
                  strokeWidth: 3,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  widget.primaryColor.withValues(alpha: 0.3),
                  widget.primaryColor.withValues(alpha: 0.05),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY:
            widget.data.map((e) => e.value).reduce((a, b) => a > b ? a : b) *
            1.2,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (_) => widget.primaryColor,
            tooltipPadding: const EdgeInsets.all(8),
            tooltipMargin: 8,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '${widget.data[groupIndex].label}\n',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: '${rod.toY.toInt()} ${widget.unit}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        titlesData: _buildTitlesData(context),
        borderData: FlBorderData(show: false),
        barGroups: widget.data.asMap().entries.map((e) {
          return BarChartGroupData(
            x: e.key,
            barRods: [
              BarChartRodData(
                toY: _animation.value * e.value.value,
                gradient: LinearGradient(
                  colors: [
                    widget.primaryColor.withValues(alpha: 0.9),
                    widget.primaryColor.withValues(alpha: 0.6),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
                width: 18,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                rodStackItems: [
                  BarChartRodStackItem(
                    0,
                    e.value.value * 0.3,
                    widget.primaryColor.withValues(alpha: 0.3),
                  ),
                  BarChartRodStackItem(
                    e.value.value * 0.3,
                    e.value.value * 0.7,
                    widget.primaryColor.withValues(alpha: 0.6),
                  ),
                  BarChartRodStackItem(
                    e.value.value * 0.7,
                    e.value.value,
                    widget.primaryColor.withValues(alpha: 0.9),
                  ),
                ],
              ),
            ],
          );
        }).toList(),
        gridData: _buildGridData(context),
      ),
    );
  }
}

class ChartData {
  final String label;
  final double value;

  ChartData({required this.label, required this.value});
}

enum ChartType { line, bar }
