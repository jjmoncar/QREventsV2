import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/guest_model.dart';

class GuestRemoteDatasource {
  final SupabaseClient _client;

  GuestRemoteDatasource(this._client);

  Future<List<GuestModel>> getGuests(String eventId) async {
    final response = await _client
        .from('guests')
        .select()
        .eq('event_id', eventId)
        .order('created_at', ascending: false);

    return (response as List)
        .map((e) => GuestModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<GuestModel> getGuest(String id) async {
    final response =
        await _client.from('guests').select().eq('id', id).single();
    return GuestModel.fromJson(response);
  }

  Future<GuestModel> addGuest(Map<String, dynamic> data) async {
    final response =
        await _client.from('guests').insert(data).select().single();
    return GuestModel.fromJson(response);
  }

  Future<GuestModel> updateGuest(String id, Map<String, dynamic> data) async {
    data['updated_at'] = DateTime.now().toIso8601String();
    final response =
        await _client.from('guests').update(data).eq('id', id).select().single();
    return GuestModel.fromJson(response);
  }

  Future<void> deleteGuest(String id) async {
    await _client.from('guests').delete().eq('id', id);
  }

  Future<List<GuestModel>> searchGuests(String eventId, String query) async {
    final response = await _client
        .from('guests')
        .select()
        .eq('event_id', eventId)
        .ilike('full_name', '%$query%')
        .order('full_name', ascending: true);

    return (response as List)
        .map((e) => GuestModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Check if adding more guests would exceed the event capacity
  Future<int> getCurrentGuestCount(String eventId) async {
    final response = await _client
        .from('guests')
        .select('total_guests')
        .eq('event_id', eventId);

    int total = 0;
    for (final row in (response as List)) {
      total += (row['total_guests'] as int?) ?? 1;
    }
    return total;
  }

  Future<void> sendInvitation(String guestId, String channel) async {
    if (channel == 'email') {
      // Call Edge Function for dynamic art email
      await _client.functions.invoke('send-invitation', body: {'guest_id': guestId});
    } else {
      // For WhatsApp/Telegram, we just update the channel in DB
      // The actual sharing is handled by the UI via share_plus
      await _client.from('guests').update({
        'invitation_channel': channel,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', guestId);
    }
  }
}
