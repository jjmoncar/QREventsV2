import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/constants/app_theme.dart';
import '../../../core/constants/app_strings.dart';
import '../../blocs/events/events_bloc.dart';
import '../../blocs/events/events_event.dart';
import '../../blocs/events/events_state.dart';

class EventsListPage extends StatefulWidget {
  const EventsListPage({super.key});

  @override
  State<EventsListPage> createState() => _EventsListPageState();
}

class _EventsListPageState extends State<EventsListPage> {
  @override
  void initState() {
    super.initState();
    context.read<EventsBloc>().add(LoadEvents());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.myEvents),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () => context.push('/events/create'),
          ),
        ],
      ),
      body: BlocBuilder<EventsBloc, EventsState>(
        builder: (context, state) {
          if (state is EventsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is EventsLoaded) {
            if (state.events.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.event_note, size: 80,
                        color: Colors.grey.shade300),
                    const SizedBox(height: 16),
                    Text(AppLocalizations.of(context)!.noEventsYet,
                        style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () => context.push('/events/create'),
                      icon: const Icon(Icons.add),
                      label: Text(AppLocalizations.of(context)!.createEvent),
                    ),
                  ],
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () async {
                context.read<EventsBloc>().add(LoadEvents());
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(AppTheme.spacingMd),
                itemCount: state.events.length,
                itemBuilder: (context, index) {
                  final event = state.events[index];
                  final emoji =
                      AppStrings.eventTypeIcons[event.type] ?? '🎉';
                  final typeLabel =
                      _getLocalizedType(context, event.type);
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      borderRadius:
                          BorderRadius.circular(AppTheme.borderRadius),
                      onTap: () => context.push('/events/${event.id}'),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              width: 54,
                              height: 54,
                              decoration: BoxDecoration(
                                color: AppColors.primaryNavy
                                    .withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Center(
                                child: Text(emoji,
                                    style: const TextStyle(fontSize: 26)),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    event.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '$typeLabel • ${_shortDate(event.dateTime)}',
                                    style: TextStyle(
                                      color: AppColors.textSecondaryLight,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(Icons.people_outline,
                                          size: 14,
                                          color: AppColors.secondaryTeal),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${event.totalConfirmed ?? 0}/${event.maxGuests}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: AppColors.secondaryTeal,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: event.isActive
                                              ? AppColors.success
                                                  .withValues(alpha: 0.1)
                                              : AppColors.textSecondaryLight
                                                  .withValues(alpha: 0.1),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          event.isActive
                                              ? AppLocalizations.of(context)!.active
                                              : AppLocalizations.of(context)!.inactive,
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: event.isActive
                                                ? AppColors.success
                                                : AppColors.textSecondaryLight,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right,
                                color: AppColors.textSecondaryLight),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
          if (state is EventsError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
    );
  }

  String _shortDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _getLocalizedType(BuildContext context, String type) {
    final l10n = AppLocalizations.of(context)!;
    switch (type) {
      case 'boda':
        return l10n.event_wedding;
      case 'cumpleanos':
        return l10n.event_birthday;
      case 'corporativo':
        return l10n.event_corporate;
      case 'quinceanera':
        return l10n.event_quinceanera;
      case 'graduacion':
        return l10n.event_graduation;
      case 'concierto':
        return l10n.event_concert;
      default:
        return l10n.event_other;
    }
  }
}
