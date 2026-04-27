import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/constants/app_theme.dart';
import '../../../core/constants/app_strings.dart';
import '../../../injection.dart';
import '../../../domain/repositories/event_repository.dart';
import '../../../domain/entities/event.dart';
import '../../blocs/guests/guests_bloc.dart';
import '../../blocs/guests/guests_event.dart';
import '../../blocs/guests/guests_state.dart';
import '../../blocs/events/events_bloc.dart';
import '../../blocs/events/events_event.dart';
import '../../blocs/events/events_state.dart';

class EventDetailPage extends StatefulWidget {
  final String eventId;
  const EventDetailPage({super.key, required this.eventId});

  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  EventEntity? _event;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadEvent();
    context.read<GuestsBloc>().add(LoadGuests(widget.eventId));
  }

  Future<void> _loadEvent() async {
    final repo = sl<EventRepository>();
    final result = await repo.getEvent(widget.eventId);
    result.fold(
      (error) => setState(() => _loading = false),
      (event) => setState(() {
        _event = event;
        _loading = false;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (_event == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(AppLocalizations.of(context)!.eventNotFound)),
      );
    }
    final event = _event!;
    final emoji = AppStrings.eventTypeIcons[event.type] ?? '🎉';

    return BlocListener<EventsBloc, EventsState>(
      listener: (context, state) {
        if (state is EventDeleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.eventDeletedSuccess),
              backgroundColor: AppColors.error,
            ),
          );
          context.pop();
        } else if (state is EventUpdated) {
          _loadEvent(); // Reload current view
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.eventUpdatedSuccess),
              backgroundColor: AppColors.success,
            ),
          );
        }
      },
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 200,
              pinned: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () => context.push('/events/create', extra: event),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => _showDeleteDialog(context, event),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: AppColors.cardGradient,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        Text(emoji, style: const TextStyle(fontSize: 48)),
                        const SizedBox(height: 8),
                        Text(
                          event.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          event.countdownText,
                          style: TextStyle(
                            color: AppColors.secondaryTealLight,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(AppTheme.spacingMd),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Info Cards
                  _infoCard(
                      Icons.calendar_today,
                      AppLocalizations.of(context)!.eventDate,
                      '${event.dateTime.day}/${event.dateTime.month}/${event.dateTime.year}'),
                  _infoCard(
                      Icons.access_time,
                      AppLocalizations.of(context)!.eventTime,
                      '${event.dateTime.hour}:${event.dateTime.minute.toString().padLeft(2, '0')}'),
                  if (event.location != null && event.location!.isNotEmpty)
                    _infoCard(
                        Icons.location_on,
                        AppLocalizations.of(context)!.eventLocation,
                        event.location!),
                  _infoCard(
                      Icons.people,
                      AppLocalizations.of(context)!.maxGuests,
                      AppLocalizations.of(context)!
                          .guestsCount(event.maxGuests)),
                  const SizedBox(height: 20),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: ElevatedButton.icon(
                          onPressed: () =>
                              context.push('/events/${event.id}/guests'),
                          icon: const Icon(Icons.people_outline),
                          label: Text(AppLocalizations.of(context)!.guests),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filled(
                        onPressed: () =>
                            context.push('/events/${event.id}/guests/add'),
                        icon: const Icon(Icons.person_add),
                        padding: const EdgeInsets.all(12),
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.secondaryTeal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                AppTheme.borderRadiusSmall),
                          ),
                        ),
                        tooltip: AppLocalizations.of(context)!.addGuest,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton.icon(
                          onPressed: () =>
                              context.push('/events/${event.id}/scanner'),
                          icon: const Icon(Icons.qr_code_scanner),
                          label: Text(AppLocalizations.of(context)!.scan),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryNavy,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Guest Stats
                  BlocBuilder<GuestsBloc, GuestsState>(
                    builder: (context, state) {
                      if (state is GuestsLoaded) {
                        return Container(
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(AppLocalizations.of(context)!.guestSummary,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w700)),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  _statColumn(
                                      AppLocalizations.of(context)!.total,
                                      '${state.totalInvited}',
                                      AppColors.primaryNavy),
                                  _statColumn(
                                      AppLocalizations.of(context)!.checkIn,
                                      '${state.totalCheckedIn}',
                                      AppColors.secondaryTeal),
                                  _statColumn(
                                      AppLocalizations.of(context)!.pending,
                                      '${state.totalPending}',
                                      AppColors.warning),
                                ],
                              ),
                            ],
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.secondaryTeal),
          const SizedBox(width: 12),
          Text(label,
              style:
                  const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          const Spacer(),
          Text(value,
              style: const TextStyle(
                  color: AppColors.textSecondaryLight, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _statColumn(String label, String value, Color color) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.w800, color: color)),
        Text(label,
            style: const TextStyle(
                fontSize: 12, color: AppColors.textSecondaryLight)),
      ],
    );
  }

  void _showDeleteDialog(BuildContext context, EventEntity event) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deleteEvent),
        content: Text(
            AppLocalizations.of(context)!.deleteEventConfirm(event.title)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<EventsBloc>().add(DeleteEvent(event.id));
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: Text(AppLocalizations.of(context)!.delete),
          ),
        ],
      ),
    );
  }
}
