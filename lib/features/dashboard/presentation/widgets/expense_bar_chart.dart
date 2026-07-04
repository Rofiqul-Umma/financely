import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/formatters.dart';
import '../../domain/entities/dashboard_summary.dart';

class ExpenseBarChart extends StatelessWidget {
  final List<MonthlyBucket> buckets;
  final double maxExpense;
  final String currencyCode;

  const ExpenseBarChart({
    super.key,
    required this.buckets,
    required this.maxExpense,
    required this.currencyCode,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final maxY = (maxExpense <= 0 ? 100.0 : maxExpense) * 1.25;
    final now = DateTime.now();
    final currentIndex = buckets.indexWhere(
        (b) => b.month.year == now.year && b.month.month == now.month);

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Spending Trend',
                style: text.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600)),
            Text('Last ${buckets.length} months',
                style: text.bodySmall
                    ?.copyWith(color: scheme.onSurfaceVariant)),
            const SizedBox(height: 20),
            SizedBox(
              height: 180,
              child: BarChart(
                BarChartData(
                  maxY: maxY,
                  alignment: BarChartAlignment.spaceAround,
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: maxY / 4,
                    getDrawingHorizontalLine: (_) => FlLine(
                      color: scheme.outlineVariant.withValues(alpha: 0.5),
                      strokeWidth: 1,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 44,
                        interval: maxY / 2,
                        getTitlesWidget: (value, meta) {
                          if (value == 0) return const SizedBox.shrink();
                          return Text(
                            Formatters.compactCurrency(value,
                                code: currencyCode),
                            style: text.labelSmall
                                ?.copyWith(color: scheme.onSurfaceVariant),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        getTitlesWidget: (value, meta) {
                          final i = value.toInt();
                          if (i < 0 || i >= buckets.length) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              Formatters.monthShort(buckets[i].month),
                              style: text.labelSmall,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: (_) => scheme.inverseSurface,
                      getTooltipItem: (group, _, rod, __) => BarTooltipItem(
                        Formatters.currency(rod.toY, code: currencyCode),
                        text.labelMedium!
                            .copyWith(color: scheme.onInverseSurface),
                      ),
                    ),
                  ),
                  barGroups: [
                    for (var i = 0; i < buckets.length; i++)
                      BarChartGroupData(
                        x: i,
                        barRods: [
                          BarChartRodData(
                            toY: buckets[i].expense,
                            width: 18,
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(6)),
                            color: i == currentIndex
                                ? scheme.primary
                                : scheme.primary.withValues(alpha: 0.35),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
