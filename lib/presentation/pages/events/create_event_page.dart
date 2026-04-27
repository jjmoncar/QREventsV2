import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/constants/app_strings.dart';
import '../../../domain/entities/event.dart';
import '../../blocs/events/events_bloc.dart';
import '../../blocs/events/events_event.dart';
import '../../blocs/events/events_state.dart';

class CreateEventPage extends StatefulWidget {
  final EventEntity? event;
  const CreateEventPage({super.key, this.event});

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _locationController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _maxGuestsController;
  late String _selectedType;
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.event?.title ?? '');
    _locationController =
        TextEditingController(text: widget.event?.location ?? '');
    _descriptionController =
        TextEditingController(text: widget.event?.description ?? '');
    _maxGuestsController =
        TextEditingController(text: widget.event?.maxGuests.toString() ?? '100');
    _selectedType = widget.event?.type ?? 'boda';
    _selectedDate = widget.event?.dateTime ??
        DateTime.now().add(const Duration(days: 30));
    _selectedTime = widget.event != null
        ? TimeOfDay.fromDateTime(widget.event!.dateTime)
        : const TimeOfDay(hour: 18, minute: 0);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _maxGuestsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EventsBloc, EventsState>(
      listener: (context, state) {
        if (state is EventCreated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.eventCreatedSuccess),
              backgroundColor: AppColors.success,
            ),
          );
          context.pop();
        } else if (state is EventsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.event != null
              ? AppLocalizations.of(context)!.editEvent
              : AppLocalizations.of(context)!.newEvent),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => context.pop(),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Event Type Selector
                Text(AppLocalizations.of(context)!.eventType,
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: AppStrings.eventTypes.map((type) {
                    final isSelected = _selectedType == type;
                    final emoji = AppStrings.eventTypeIcons[type] ?? '🎉';
                    final label = _getLocalizedType(context, type);
                    return ChoiceChip(
                      label: Text('$emoji $label'),
                      selected: isSelected,
                      onSelected: (_) =>
                          setState(() => _selectedType = type),
                      selectedColor: AppColors.primaryNavy,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : null,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                // Title
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.eventName,
                    prefixIcon: const Icon(Icons.celebration),
                  ),
                  validator: (v) => v == null || v.isEmpty
                      ? AppLocalizations.of(context)!.enterEventName
                      : null,
                ),
                const SizedBox(height: 16),

                // Date & Time
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: _pickDate,
                        child: InputDecorator(
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!.eventDate,
                            prefixIcon: const Icon(Icons.calendar_today),
                          ),
                          child: Text(
                            '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InkWell(
                        onTap: _pickTime,
                        child: InputDecorator(
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!.eventTime,
                            prefixIcon: const Icon(Icons.access_time),
                          ),
                          child: Text(_selectedTime.format(context)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Location
                TextFormField(
                  controller: _locationController,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.eventLocation,
                    prefixIcon: const Icon(Icons.location_on_outlined),
                  ),
                ),
                const SizedBox(height: 16),

                // Max Guests
                TextFormField(
                  controller: _maxGuestsController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.maxGuests,
                    prefixIcon: const Icon(Icons.people_outline),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return AppLocalizations.of(context)!.enterCapacity;
                    final value = int.tryParse(v);
                    if (value == null) return AppLocalizations.of(context)!.invalidNumber;
                    
                    final minAllowed = widget.event?.totalWithQr ?? 0;
                    if (value < minAllowed) {
                      return 'No se puede reducir por debajo de los QR ya enviados ($minAllowed)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Description
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.eventDescription,
                    prefixIcon: const Icon(Icons.description_outlined),
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 32),

                // Submit
                SizedBox(
                  height: 54,
                  child: BlocBuilder<EventsBloc, EventsState>(
                    builder: (context, state) {
                      return ElevatedButton.icon(
                        onPressed:
                            state is EventsLoading ? null : _onCreate,
                        icon: state is EventsLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2),
                              )
                            : const Icon(Icons.check),
                        label: Text(widget.event != null
                            ? AppLocalizations.of(context)!.saveChanges.toUpperCase()
                            : AppLocalizations.of(context)!.createEvent.toUpperCase()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (date != null) setState(() => _selectedDate = date);
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (time != null) setState(() => _selectedTime = time);
  }

  void _onCreate() {
    if (_formKey.currentState!.validate()) {
      final dateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );
      final userId = Supabase.instance.client.auth.currentUser?.id ?? '';
      final event = EventEntity(
        id: widget.event?.id ?? '',
        ownerId: widget.event?.ownerId ?? userId,
        title: _titleController.text.trim(),
        type: _selectedType,
        dateTime: dateTime,
        location: _locationController.text.trim(),
        description: _descriptionController.text.trim(),
        maxGuests: int.tryParse(_maxGuestsController.text) ?? 100,
        status: widget.event?.status ?? 'active',
      );

      if (widget.event != null) {
        context.read<EventsBloc>().add(UpdateEvent(event));
      } else {
        context.read<EventsBloc>().add(CreateEvent(event));
      }
    }
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
