import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../core/constants/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/constants/app_theme.dart';
import '../../../core/constants/app_strings.dart';
import '../../../domain/entities/event.dart';
import '../../../domain/entities/guest.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_state.dart';
import '../../blocs/events/events_bloc.dart';
import '../../blocs/events/events_event.dart';
import '../../blocs/events/events_state.dart';
import '../../blocs/guests/guests_bloc.dart';
import '../../blocs/guests/guests_event.dart';
import '../../blocs/guests/guests_state.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    context.read<EventsBloc>().add(LoadEvents());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            context.read<EventsBloc>().add(LoadEvents());
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppTheme.spacingMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildGreeting(),
                const SizedBox(height: 20),
                _buildNextEventCard(),
                const SizedBox(height: 20),
                _buildStatsChart(),
                const SizedBox(height: 20),
                _buildScanButton(),
                const SizedBox(height: 20),
                _buildQuickGuestList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGreeting() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final name = state is AuthAuthenticated
            ? state.user.name?.split(' ').first ?? 'Usuario'
            : 'Usuario';
        return Text(
          AppLocalizations.of(context)!.hello(name),
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: AppColors.primaryNavy,
              ),
        );
      },
    );
  }

  Widget _buildNextEventCard() {
    return BlocBuilder<EventsBloc, EventsState>(
      builder: (context, state) {
        if (state is EventsLoading) {
          return _shimmerCard(height: 160);
        }
        if (state is EventsLoaded && state.nextEvent != null) {
          final event = state.nextEvent!;
          // Load guests for this event
          context.read<GuestsBloc>().add(LoadGuests(event.id));
          return _eventCard(event);
        }
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: AppColors.cardGradient,
            borderRadius: BorderRadius.circular(AppTheme.borderRadius),
          ),
          child: Center(
            child: Text(
              AppLocalizations.of(context)!.noEventsFound,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        );
      },
    );
  }

  Widget _eventCard(EventEntity event) {
    final emoji = AppStrings.eventTypeIcons[event.type] ?? '🎉';
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryNavy.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${AppLocalizations.of(context)!.myNextEvent} $emoji',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            event.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _formatDate(event.dateTime),
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.timer_outlined,
                  color: AppColors.secondaryTealLight, size: 16),
              const SizedBox(width: 4),
              Text(
                '${AppLocalizations.of(context)!.countdown}: ${event.countdownText}',
                style: const TextStyle(
                  color: AppColors.secondaryTealLight,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsChart() {
    return BlocBuilder<GuestsBloc, GuestsState>(
      builder: (context, state) {
        int estimated = 0;
        int confirmed = 0;
        int pending = 0;

        if (state is GuestsLoaded) {
          estimated = state.totalInvited;
          confirmed = state.totalCheckedIn;
          pending = state.totalPending;
        }

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(AppTheme.borderRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.estimatedAttendance,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariantLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _legendDot(AppColors.primaryNavy),
                        Text(' ${AppLocalizations.of(context)!.total}', style: const TextStyle(fontSize: 10)),
                        const SizedBox(width: 8),
                        _legendDot(AppColors.secondaryTeal),
                        Text(' ${AppLocalizations.of(context)!.confirmed}',
                            style: const TextStyle(fontSize: 10)),
                        const SizedBox(width: 8),
                        _legendDot(AppColors.textSecondaryLight),
                        Text(' ${AppLocalizations.of(context)!.pending}',
                            style: const TextStyle(fontSize: 10)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 180,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: (estimated > 0 ? estimated.toDouble() : 10) * 1.2,
                    barGroups: [
                      _barGroup(0, estimated.toDouble(),
                          AppColors.primaryNavy),
                      _barGroup(1, confirmed.toDouble(),
                          AppColors.secondaryTeal),
                      _barGroup(
                          2, pending.toDouble(), AppColors.textSecondaryLight),
                    ],
                    titlesData: FlTitlesData(
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final labels = [
                              AppLocalizations.of(context)!.total,
                              AppLocalizations.of(context)!.confirmed,
                              AppLocalizations.of(context)!.pending
                            ];
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                labels[value.toInt()],
                                style: const TextStyle(fontSize: 11),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    gridData: const FlGridData(show: false),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _statPill(AppLocalizations.of(context)!.totalInvited, '$estimated',
                      AppColors.primaryNavy),
                  _statPill(AppLocalizations.of(context)!.confirmed, '$confirmed',
                      AppColors.secondaryTeal),
                  _statPill(AppLocalizations.of(context)!.pending, '$pending',
                      AppColors.textSecondaryLight),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildScanButton() {
    return BlocBuilder<EventsBloc, EventsState>(
      builder: (context, state) {
        final eventId = state is EventsLoaded ? state.nextEvent?.id : null;
        return SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton.icon(
            onPressed: eventId != null
                ? () => context.push('/events/$eventId/scanner')
                : null,
            icon: const Icon(Icons.qr_code_scanner, size: 24),
            label: Text(
              AppLocalizations.of(context)!.scanGuests,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
                fontSize: 15,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondaryTeal,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(AppTheme.borderRadiusSmall),
              ),
              elevation: 3,
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickGuestList() {
    return BlocBuilder<GuestsBloc, GuestsState>(
      builder: (context, state) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.quickGuestList,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                if (state is GuestsLoaded)
                  TextButton.icon(
                    onPressed: () =>
                        context.push('/events/${state.eventId}/guests'),
                    icon: const Icon(Icons.search, size: 18),
                    label: Text(AppLocalizations.of(context)!.search),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            if (state is GuestsLoading)
              const Center(child: CircularProgressIndicator()),
            if (state is GuestsLoaded)
              ...state.guests.take(5).map((g) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius:
                          BorderRadius.circular(AppTheme.borderRadiusSmall),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: AppColors.primaryNavy
                              .withValues(alpha: 0.1),
                          child: Text(
                            g.initials,
                            style: const TextStyle(
                              color: AppColors.primaryNavy,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                g.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 2),
                              _statusBadge(g.status),
                              if (g.isGroup) ...[
                                const SizedBox(width: 8),
                                Text(
                                  '(${g.guestsCheckedIn}/${g.totalGuests})',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondaryLight,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () => _showGuestDetails(context, g),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            minimumSize: Size.zero,
                            side: const BorderSide(
                                color: AppColors.primaryNavy, width: 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.viewDetails,
                            style: const TextStyle(fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                  )),
            if (state is GuestsLoaded && state.guests.isEmpty)
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  AppLocalizations.of(context)!.noGuestsFound,
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        );
      },
    );
  }

  // ─── Helper Widgets ───
  Widget _shimmerCard({required double height}) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
      ),
    );
  }

  Widget _legendDot(Color color) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  BarChartGroupData _barGroup(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 32,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
        ),
      ],
    );
  }

  Widget _statPill(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryLight),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    const days = [
      'Lunes', 'Martes', 'Miércoles', 'Jueves',
      'Viernes', 'Sábado', 'Domingo'
    ];
    return '${days[date.weekday - 1]}, ${date.day} de ${months[date.month - 1]}, ${date.year}';
  }

  void _showGuestDetails(BuildContext context, GuestEntity guest) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(AppTheme.borderRadius)),
        ),
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.primaryNavy.withValues(alpha: 0.1),
                  child: Text(
                    guest.initials,
                    style: const TextStyle(
                      color: AppColors.primaryNavy,
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        guest.name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      const SizedBox(height: 4),
                      _statusBadge(guest.status),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 32),
            Text(
              AppLocalizations.of(context)!.info,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondaryLight,
                fontSize: 12,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 16),
            if (guest.isGroup)
              _detailItem(Icons.group_outlined, AppLocalizations.of(context)!.groupInvitation(guest.totalGuests), 
                          '${guest.guestsCheckedIn} ${AppLocalizations.of(context)!.confirmed}'),
            if (guest.whatsapp?.isNotEmpty ?? false)
              _detailItem(Icons.chat_outlined, AppLocalizations.of(context)!.whatsapp, guest.whatsapp!),
            if (guest.telegram?.isNotEmpty ?? false)
              _detailItem(Icons.telegram_outlined, AppLocalizations.of(context)!.telegram, guest.telegram!),
            if (guest.email?.isNotEmpty ?? false)
              _detailItem(Icons.email_outlined, AppLocalizations.of(context)!.email, guest.email!),
            if (guest.notes?.isNotEmpty ?? false) ...[
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.eventDescription,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondaryLight,
                  fontSize: 12,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariantLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(guest.notes!),
              ),
            ],
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(AppLocalizations.of(context)!.cancel),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primaryNavy.withValues(alpha: 0.6)),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryLight)),
              Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String status) {
    if (!mounted) return const SizedBox();
    final isCheckedIn = status == 'checked_in';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: (isCheckedIn ? AppColors.success : AppColors.warning)
            .withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isCheckedIn ? Icons.check_circle : Icons.pending,
            size: 12,
            color: isCheckedIn ? AppColors.success : AppColors.warning,
          ),
          const SizedBox(width: 4),
          Text(
            isCheckedIn
                ? AppLocalizations.of(context)!.confirmed
                : AppLocalizations.of(context)!.pending,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isCheckedIn ? AppColors.success : AppColors.warning,
            ),
          ),
        ],
      ),
    );
  }
}
