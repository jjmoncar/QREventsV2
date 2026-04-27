import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/constants/app_theme.dart';
import '../../../domain/entities/guest.dart';
import '../../blocs/guests/guests_bloc.dart';
import '../../blocs/guests/guests_event.dart';
import '../../blocs/guests/guests_state.dart';

class AddGuestPage extends StatefulWidget {
  final String eventId;
  final GuestEntity? guest;
  const AddGuestPage({super.key, required this.eventId, this.guest});

  @override
  State<AddGuestPage> createState() => _AddGuestPageState();
}

class _AddGuestPageState extends State<AddGuestPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _whatsappController;
  late final TextEditingController _telegramController;
  late final TextEditingController _phoneController;
  late final TextEditingController _notesController;
  late int _totalGuests;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.guest?.name ?? '');
    _emailController = TextEditingController(text: widget.guest?.email ?? '');
    _whatsappController =
        TextEditingController(text: widget.guest?.whatsapp ?? '');
    _telegramController =
        TextEditingController(text: widget.guest?.telegram ?? '');
    _phoneController = TextEditingController(text: widget.guest?.phone ?? '');
    _notesController = TextEditingController(text: widget.guest?.notes ?? '');
    _totalGuests = widget.guest?.totalGuests ?? 1;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _whatsappController.dispose();
    _telegramController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GuestsBloc, GuestsState>(
      listener: (context, state) {
        if (state is GuestAdded) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.guestAddedSuccess(state.guest.name)),
              backgroundColor: AppColors.success,
            ),
          );
          context.pop();
        } else if (state is GuestsError) {
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
          title: Text(widget.guest != null
              ? AppLocalizations.of(context)!.editGuest
              : AppLocalizations.of(context)!.addGuest),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Name
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.guestNameHint,
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? AppLocalizations.of(context)!.nameHint : null,
                ),
                const SizedBox(height: 16),

                // Total Guests (Group)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariantLight,
                    borderRadius:
                        BorderRadius.circular(AppTheme.borderRadiusSmall),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.groups_outlined,
                          color: AppColors.primaryNavy),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.peopleCount,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 14),
                            ),
                            Text(
                              _totalGuests == 1
                                  ? AppLocalizations.of(context)!.individualInvitation
                                  : AppLocalizations.of(context)!.groupInvitation(_totalGuests),
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondaryLight),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: _totalGuests > 1
                                ? () =>
                                    setState(() => _totalGuests--)
                                : null,
                            color: AppColors.primaryNavy,
                          ),
                          Text(
                            '$_totalGuests',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryNavy,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () =>
                                setState(() => _totalGuests++),
                            color: AppColors.primaryNavy,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Contact Methods
                Text(AppLocalizations.of(context)!.contactData,
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.email,
                    prefixIcon: const Icon(Icons.email_outlined),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _whatsappController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.whatsapp,
                    prefixIcon: const Icon(Icons.chat_outlined),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _telegramController,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.telegram,
                    prefixIcon: const Icon(Icons.send_outlined),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.phone,
                    prefixIcon: const Icon(Icons.phone_outlined),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _notesController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.notesOptional,
                    prefixIcon: const Icon(Icons.note_outlined),
                  ),
                ),
                const SizedBox(height: 32),

                SizedBox(
                  height: 54,
                  child: ElevatedButton.icon(
                    onPressed: _onSave,
                    icon: Icon(widget.guest != null ? Icons.save : Icons.person_add),
                    label: Text(widget.guest != null
                        ? AppLocalizations.of(context)!.saveChanges.toUpperCase()
                        : AppLocalizations.of(context)!.addGuest.toUpperCase()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onSave() {
    if (_formKey.currentState!.validate()) {
      final guest = GuestEntity(
        id: widget.guest?.id ?? '',
        eventId: widget.eventId,
        name: _nameController.text.trim(),
        email: _emailController.text.trim().isNotEmpty
            ? _emailController.text.trim()
            : null,
        whatsapp: _whatsappController.text.trim().isNotEmpty
            ? _whatsappController.text.trim()
            : null,
        telegram: _telegramController.text.trim().isNotEmpty
            ? _telegramController.text.trim()
            : null,
        phone: _phoneController.text.trim().isNotEmpty
            ? _phoneController.text.trim()
            : null,
        totalGuests: _totalGuests,
        notes: _notesController.text.trim().isNotEmpty
            ? _notesController.text.trim()
            : null,
        status: widget.guest?.status ?? 'pending',
        qrCodeToken: widget.guest?.qrCodeToken ?? '',
        guestsCheckedIn: widget.guest?.guestsCheckedIn ?? 0,
        createdAt: widget.guest?.createdAt,
      );

      if (widget.guest != null) {
        context.read<GuestsBloc>().add(UpdateGuest(guest));
      } else {
        context.read<GuestsBloc>().add(AddGuest(guest));
      }
    }
  }
}
