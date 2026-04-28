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
    
    var profile = await _client
        .from('profiles')
        .select()
        .eq('id', response.user!.id)
        .maybeSingle();

    if (profile == null) {
      // Auto-create profile if missing
      final newProfile = {
        'id': response.user!.id,
        'email': response.user!.email ?? '',
        'full_name': response.user!.userMetadata?['full_name'],
        'role': 'admin',
      };
      await _client.from('profiles').insert(newProfile);
      profile = newProfile;
    } else {
      profile['email'] = response.user!.email ?? '';
    }
    
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
    // But we use a small delay and maybeSingle just in case
    await Future.delayed(const Duration(milliseconds: 500));
    
    var profile = await _client
        .from('profiles')
        .select()
        .eq('id', response.user!.id)
        .maybeSingle();
        
    if (profile == null) {
      final newProfile = {
        'id': response.user!.id,
        'email': response.user!.email ?? '',
        'full_name': name,
        'role': 'admin',
      };
      await _client.from('profiles').insert(newProfile);
      profile = newProfile;
    } else {
      profile['email'] = response.user!.email ?? '';
    }
    
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
    
    var profile = await _client.from('profiles').select().eq('id', user.id).maybeSingle();
    
    if (profile == null) {
      // Profile missing! Let's create it
      final newProfile = {
        'id': user.id,
        'email': user.email ?? '',
        'full_name': user.userMetadata?['full_name'],
        'role': 'admin',
      };
      await _client.from('profiles').insert(newProfile);
      profile = newProfile;
    } else {
      profile['email'] = user.email ?? '';
    }
    
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
    
    profile['email'] = _client.auth.currentUser?.email ?? '';
    return UserModel.fromJson(profile);
  }
}
