import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../core/constants/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/constants/app_theme.dart';
import '../../blocs/events/events_bloc.dart';
import '../../blocs/events/events_event.dart';
import '../../blocs/events/events_state.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  @override
  void initState() {
    super.initState();
    context.read<EventsBloc>().add(LoadEvents());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.analytics),
      ),
      body: BlocBuilder<EventsBloc, EventsState>(
        builder: (context, state) {
          if (state is EventsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is EventsLoaded) {
            final events = state.events;
            int totalInvited = 0;
            int totalConfirmed = 0;
            for (final e in events) {
              totalInvited += e.totalInvited ?? 0;
              totalConfirmed += e.totalConfirmed ?? 0;
            }
            final totalPending = totalInvited - totalConfirmed;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacingMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // KPIs
                  Row(
                    children: [
                      _kpiCard(AppLocalizations.of(context)!.events, '${events.length}',
                          Icons.event, AppColors.primaryNavy),
                      const SizedBox(width: 12),
                      _kpiCard(AppLocalizations.of(context)!.guests, '$totalInvited',
                          Icons.people, AppColors.secondaryTeal),
                      const SizedBox(width: 12),
                      _kpiCard(
                          AppLocalizations.of(context)!.checkIn,
                          totalInvited > 0
                              ? '${(totalConfirmed / totalInvited * 100).toStringAsFixed(0)}%'
                              : '0%',
                          Icons.qr_code_scanner,
                          AppColors.accent),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Donut Chart
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius:
                          BorderRadius.circular(AppTheme.borderRadius),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.confirmedVsPending,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 200,
                          child: PieChart(
                            PieChartData(
                              sectionsSpace: 4,
                              centerSpaceRadius: 50,
                              sections: [
                                PieChartSectionData(
                                  value: totalConfirmed.toDouble(),
                                  color: AppColors.secondaryTeal,
                                  title: '$totalConfirmed',
                                  titleStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                  ),
                                  radius: 50,
                                ),
                                PieChartSectionData(
                                  value: totalPending > 0
                                      ? totalPending.toDouble()
                                      : 1,
                                  color: AppColors.textSecondaryLight
                                      .withValues(alpha: 0.3),
                                  title: '$totalPending',
                                  titleStyle: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                  ),
                                  radius: 45,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _legendItem(AppLocalizations.of(context)!.confirmed,
                                AppColors.secondaryTeal),
                            const SizedBox(width: 24),
                            _legendItem(AppLocalizations.of(context)!.pending,
                                AppColors.textSecondaryLight),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Per-Event stats
                  Text(
                    AppLocalizations.of(context)!.perEvent,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 12),
                  ...events.map((e) => Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(
                              AppTheme.borderRadiusSmall),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              e.title,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 8),
                            LinearProgressIndicator(
                              value: (e.totalInvited ?? 0) > 0
                                  ? (e.totalConfirmed ?? 0) /
                                      (e.totalInvited ?? 1)
                                  : 0,
                              backgroundColor: AppColors
                                  .textSecondaryLight
                                  .withValues(alpha: 0.2),
                              valueColor:
                                  const AlwaysStoppedAnimation<Color>(
                                      AppColors.secondaryTeal),
                              borderRadius: BorderRadius.circular(4),
                              minHeight: 8,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${e.totalConfirmed ?? 0}/${e.totalInvited ?? 0} ${AppLocalizations.of(context)!.checkIns}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondaryLight,
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _kpiCard(
      String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _legendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}
