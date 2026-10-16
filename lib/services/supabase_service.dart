import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static SupabaseClient? _client;

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: 'https://lipfzrxwmjzqyvscbafe.supabase.co',
      anonKey: 'sb_publishable_8DA1v8qCkdZQZmcqAwE9aA_dcLwagsd',
    );
    _client = Supabase.instance.client;
  }

  static SupabaseClient get client {
    if (_client == null) {
      throw Exception('Supabase belum diinisialisasi');
    }
    return _client!;
  }

  // Helper untuk mendapatkan user ID yang sedang login
  static String? get currentUserId => _client?.auth.currentUser?.id;

  // Helper untuk cek apakah user sudah login
  static bool get isLoggedIn => _client?.auth.currentUser != null;
}
