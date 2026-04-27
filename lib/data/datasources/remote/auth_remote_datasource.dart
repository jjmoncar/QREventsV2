import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/user_model.dart';

class AuthRemoteDatasource {
  final SupabaseClient _client;

  AuthRemoteDatasource(this._client);

  Future<UserModel> login(String email, String password) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    if (response.user == null) {
      throw Exception('Error al iniciar sesión');
    }
    final profile = await _client
        .from('profiles')
        .select()
        .eq('id', response.user!.id)
        .single();
    return UserModel.fromJson(profile);
  }

  Future<UserModel> register(
      String email, String password, String name) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': name},
    );
    if (response.user == null) {
      throw Exception('Error al registrar usuario');
    }

    // Profile is created automatically by database trigger


    final profile = await _client
        .from('profiles')
        .select()
        .eq('id', response.user!.id)
        .single();
    return UserModel.fromJson(profile);
  }

  Future<void> verifyEmail(String token) async {
    await _client.auth.verifyOTP(
      type: OtpType.email,
      token: token,
      email: '',
    );
  }

  Future<UserModel?> getCurrentUser() async {
    final user = _client.auth.currentUser;
    if (user == null) return null;
    final profile =
        await _client.from('profiles').select().eq('id', user.id).single();
    return UserModel.fromJson(profile);
  }

  Future<void> logout() async {
    await _client.auth.signOut();
  }

  Future<UserModel> updateProfile(
      String userId, {String? name, String? avatarUrl}) async {
    final updates = <String, dynamic>{'updated_at': DateTime.now().toIso8601String()};
    if (name != null) updates['full_name'] = name;
    if (avatarUrl != null) updates['avatar_url'] = avatarUrl;

    await _client.from('profiles').update(updates).eq('id', userId);
    final profile =
        await _client.from('profiles').select().eq('id', userId).single();
    return UserModel.fromJson(profile);
  }
}
