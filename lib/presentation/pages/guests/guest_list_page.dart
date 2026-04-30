import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../core/constants/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/constants/app_theme.dart';
import '../../../domain/entities/guest.dart';
import '../../../domain/entities/event.dart';
import '../../blocs/guests/guests_bloc.dart';
import '../../blocs/guests/guests_event.dart';
import '../../blocs/guests/guests_state.dart';

class GuestListPage extends StatefulWidget {
  final String eventId;
  const GuestListPage({super.key, required this.eventId});

  @override
  State<GuestListPage> createState() => _GuestListPageState();
}

class _GuestListPageState extends State<GuestListPage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<GuestsBloc>().add(LoadGuests(widget.eventId));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.guests),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingMd),
            child: TextField(
              controller: _searchController,
              onChanged: (query) {
                context.read<GuestsBloc>().add(
                      SearchGuests(
                          eventId: widget.eventId, query: query),
                    );
              },
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.searchGuest,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          context
                              .read<GuestsBloc>()
                              .add(LoadGuests(widget.eventId));
                        },
                      )
                    : null,
              ),
            ),
          ),

          // Guest List
          Expanded(
            child: BlocBuilder<GuestsBloc, GuestsState>(
              builder: (context, state) {
                if (state is GuestsLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is GuestsLoaded) {
                  if (state.guests.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.group_add_outlined,
                            size: 64,
                            color: AppColors.textSecondaryLight,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            AppLocalizations.of(context)!.noGuestsFound,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.textSecondaryLight,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: () => context.push(
                                '/events/${widget.eventId}/guests/add'),
                            icon: const Icon(Icons.person_add),
                            label: Text(AppLocalizations.of(context)!
                                .addGuest
                                .toUpperCase()),
                          ),
                        ],
                      ),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () async {
                      context
                          .read<GuestsBloc>()
                          .add(LoadGuests(widget.eventId));
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacingMd),
                      itemCount: state.guests.length,
                      itemBuilder: (context, index) {
                        final guest = state.guests[index];
                        return Dismissible(
                          key: Key(guest.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            decoration: BoxDecoration(
                              color: AppColors.error,
                              borderRadius: BorderRadius.circular(
                                  AppTheme.borderRadiusSmall),
                            ),
                            child: const Icon(Icons.delete,
                                color: Colors.white),
                          ),
                          confirmDismiss: (_) async {
                            return await showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title:
                                    Text(AppLocalizations.of(context)!.deleteGuest),
                                content: Text(
                                    AppLocalizations.of(context)!.deleteGuestConfirm(guest.name)),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(ctx).pop(false),
                                    child: Text(AppLocalizations.of(context)!.cancel),
                                  ),
                                  ElevatedButton(
                                    onPressed: () =>
                                        Navigator.of(ctx).pop(true),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            AppColors.error),
                                    child: Text(AppLocalizations.of(context)!.delete),
                                  ),
                                ],
                              ),
                            );
                          },
                          onDismissed: (_) {
                            context.read<GuestsBloc>().add(
                                  DeleteGuest(
                                    guestId: guest.id,
                                    eventId: widget.eventId,
                                  ),
                                );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(
                                  AppTheme.borderRadiusSmall),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundColor: AppColors.primaryNavy
                                      .withValues(alpha: 0.1),
                                  child: Text(
                                    guest.initials,
                                    style: const TextStyle(
                                      color: AppColors.primaryNavy,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        guest.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          _statusBadge(guest.status),
                                          if (guest.isGroup) ...[
                                            const SizedBox(width: 8),
                                            Text(
                                              '${guest.guestsCheckedIn}/${guest.totalGuests} ${AppLocalizations.of(context)!.people}',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: AppColors
                                                    .textSecondaryLight,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit_outlined,
                                          color: AppColors.primaryNavy,
                                          size: 20),
                                      onPressed: () => context.push(
                                        '/events/${widget.eventId}/guests/add',
                                        extra: guest,
                                      ),
                                      tooltip:
                                          AppLocalizations.of(context)!.editGuest,
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline,
                                          color: AppColors.error,
                                          size: 20),
                                      onPressed: () async {
                                        final confirm = await showDialog<bool>(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            title: Text(AppLocalizations.of(context)!.deleteGuest),
                                            content: Text(AppLocalizations.of(context)!.deleteGuestConfirm(guest.name)),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.of(ctx).pop(false),
                                                child: Text(AppLocalizations.of(context)!.cancel),
                                              ),
                                              ElevatedButton(
                                                onPressed: () => Navigator.of(ctx).pop(true),
                                                style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                                                child: Text(AppLocalizations.of(context)!.delete),
                                              ),
                                            ],
                                          ),
                                        );
                                        if (confirm == true) {
                                          context.read<GuestsBloc>().add(
                                            DeleteGuest(
                                              guestId: guest.id,
                                              eventId: widget.eventId,
                                            ),
                                          );
                                        }
                                      },
                                      tooltip: AppLocalizations.of(context)!.delete,
                                    ),
                                    if (guest.hasContactMethod)
                                      IconButton(
                                        icon: const Icon(Icons.send,
                                            color: AppColors.secondaryTeal,
                                            size: 20),
                                        onPressed: () =>
                                            _sendInvitation(guest, state.event),
                                        tooltip: AppLocalizations.of(context)!
                                            .sendInvitation,
                                      ),
                                  ],
                                ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                  if (state is GuestsError) {
                    return Center(child: Text(state.message));
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/events/${widget.eventId}/guests/add'),
        backgroundColor: AppColors.primaryNavy,
        tooltip: AppLocalizations.of(context)!.addGuest,
        child: const Icon(Icons.person_add, color: Colors.white),
      ),
    );
  }

  void _sendInvitation(GuestEntity guest, EventEntity? event) {
    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppLocalizations.of(context)!.sendInvitation,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            if (guest.hasEmail)
              _invitationChannelTile(
                icon: Icons.email_outlined,
                title: 'Email (Arte Dinámico)',
                subtitle: guest.email!,
                color: AppColors.primaryNavy,
                onTap: () {
                  Navigator.pop(context);
                  _processInvitation(guest, 'email', event);
                },
              ),
            if (guest.hasWhatsApp)
              _invitationChannelTile(
                icon: Icons.chat_bubble_outline,
                title: 'WhatsApp',
                subtitle: guest.whatsapp!,
                color: Colors.green,
                onTap: () {
                  Navigator.pop(context);
                  _processInvitation(guest, 'whatsapp', event);
                },
              ),
            if (guest.hasTelegram)
              _invitationChannelTile(
                icon: Icons.telegram,
                title: 'Telegram',
                subtitle: guest.telegram!,
                color: Colors.blue,
                onTap: () {
                  Navigator.pop(context);
                  _processInvitation(guest, 'telegram', event);
                },
              ),
            const Divider(height: 32),
            _invitationChannelTile(
              icon: Icons.qr_code,
              title: 'Compartir Imagen QR',
              subtitle: 'Enviar el código QR como imagen',
              color: AppColors.secondaryTeal,
              onTap: () {
                Navigator.pop(context);
                _shareQRImage(guest, event);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _invitationChannelTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: 0.1),
        child: Icon(icon, color: color),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      onTap: onTap,
    );
  }

  void _processInvitation(GuestEntity guest, String channel, EventEntity? event) async {
    // 1. Notify Backend / Edge Function
    context.read<GuestsBloc>().add(SendInvitation(guest: guest, channel: channel));

    final baseUrl = dotenv.env['NEXT_PUBLIC_APP_URL'] ?? 'https://guestly.app';
    final invitationLink = '$baseUrl/invitation/${guest.qrCodeToken}';
    final eventName = event?.title ?? AppLocalizations.of(context)!.eventName;
    final eventType = event?.type ?? 'other';
    
    final l10n = AppLocalizations.of(context)!;
    String message;

    switch (eventType) {
      case 'boda':
        message = l10n.invitationWedding(guest.name, eventName, invitationLink);
        break;
      case 'cumpleanos':
        message = l10n.invitationBirthday(guest.name, eventName, invitationLink);
        break;
      case 'corporativo':
        message = l10n.invitationCorporate(guest.name, eventName, invitationLink);
        break;
      default:
        message = l10n.invitationMessage(guest.name, eventName, invitationLink);
    }

    if (channel == 'whatsapp' && guest.whatsapp != null) {
      final phone = guest.whatsapp!.replaceAll(RegExp(r'[^\d+]'), '');
      final whatsappUrl = Uri.parse("whatsapp://send?phone=$phone&text=${Uri.encodeComponent(message)}");
      
      if (await canLaunchUrl(whatsappUrl)) {
        await launchUrl(whatsappUrl);
      } else {
        // Fallback to share
        await Share.share(message);
      }
    } else if (channel == 'email') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Enviando invitación por Email a ${guest.email}...'),
          backgroundColor: AppColors.primaryNavy,
        ),
      );
    } else {
      // Default fallback (Telegram or others)
      await Share.share(message);
    }
  }

  Future<void> _shareQRImage(GuestEntity guest, EventEntity? event) async {
    try {
      final qrValidationResult = QrValidator.validate(
        data: guest.qrCodeToken ?? '',
        version: QrVersions.auto,
        errorCorrectionLevel: QrErrorCorrectLevel.L,
      );

      if (qrValidationResult.status == QrValidationStatus.valid) {
        final qrCode = qrValidationResult.qrCode!;
        final painter = QrPainter.withQr(
          qr: qrCode,
          color: const Color(0xFF000000),
          emptyColor: const Color(0xFFFFFFFF),
          gapless: true,
        );

        final directory = await getTemporaryDirectory();
        final path = '${directory.path}/qr_${guest.id}.png';
        final picData = await painter.toImageData(300);
        
        if (picData != null) {
          final file = File(path);
          await file.writeAsBytes(picData.buffer.asUint8List());
          await Share.shareXFiles([XFile(path)], text: 'Código QR de ${guest.name} para ${event?.title ?? 'el evento'}');
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al compartir QR: $e')),
        );
      }
    }
  }

  Widget _statusBadge(String status) {
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
            isCheckedIn ? AppLocalizations.of(context)!.confirmed : AppLocalizations.of(context)!.pending,
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
