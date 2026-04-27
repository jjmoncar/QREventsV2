import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/event_model.dart';

class EventRemoteDatasource {
  final SupabaseClient _client;

  EventRemoteDatasource(this._client);

  Future<List<EventModel>> getEvents() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('No autenticado');

    final response = await _client
        .from('events')
        .select('*, guests(total_guests, guests_checked_in, status, attendance_status, qr_code_token)')
        .eq('owner_id', userId)
        .order('date', ascending: true);

    return (response as List)
        .map((e) => EventModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<EventModel> getEvent(String id) async {
    final response = await _client
        .from('events')
        .select('*, guests(total_guests, guests_checked_in, status, attendance_status, qr_code_token)')
        .eq('id', id)
        .single();
    return EventModel.fromJson(response);
  }

  Future<EventModel> createEvent(Map<String, dynamic> data) async {
    final response =
        await _client.from('events').insert(data).select().single();
    return EventModel.fromJson(response);
  }

  Future<EventModel> updateEvent(String id, Map<String, dynamic> data) async {
    data['updated_at'] = DateTime.now().toIso8601String();
    final response =
        await _client.from('events').update(data).eq('id', id).select().single();
    return EventModel.fromJson(response);
  }

  Future<void> deleteEvent(String id) async {
    await _client.from('events').delete().eq('id', id);
  }

  Future<EventModel?> getNextEvent() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('No autenticado');

    final response = await _client
        .from('events')
        .select('*, guests(total_guests, guests_checked_in, status, attendance_status, qr_code_token)')
        .eq('owner_id', userId)
        .eq('status', 'pending')
        .gte('date', DateTime.now().toIso8601String())
        .order('date', ascending: true)
        .limit(1);

    final list = response as List;
    if (list.isEmpty) return null;
    return EventModel.fromJson(list.first as Map<String, dynamic>);
  }

  Future<void> triggerNotifications(String eventId, String changeType) async {
    await _client.functions.invoke('event-notifications', body: {
      'event_id': eventId,
      'change_type': changeType,
    });
  }
}
