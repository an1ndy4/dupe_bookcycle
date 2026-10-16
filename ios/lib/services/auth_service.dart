import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';
import 'supabase_service.dart';

class AuthService {
  final SupabaseClient _client = SupabaseService.client;

  // ==================== REGISTER ====================
  Future<AuthResponse> register({
    required String email,
    required String password,
    required String namaLengkap,
    String? nomorHp,
    String? alamat,
  }) async {
    try {
      // 1. Register ke Supabase Auth
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {
          'nama_lengkap': namaLengkap,
          'nomor_hp': nomorHp ?? '',
        },
      );

      // 2. Jika berhasil, simpan data tambahan ke tabel users
      if (response.user != null) {
        await _client.from('users').insert({
          'nama_lengkap': namaLengkap,
          'email': email,
          'nomor_hp': nomorHp,
          'alamat': alamat,
          'password': password, // Catatan: Supabase Auth sudah handle password
        });
      }

      return response;
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  // ==================== LOGIN ====================
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      return await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  // ==================== LOGOUT ====================
  Future<void> logout() async {
    try {
      await _client.auth.signOut();
    } catch (e) {
      throw Exception('Gagal logout: $e');
    }
  }

  // ==================== GET CURRENT USER ====================
  User? get currentUser => _client.auth.currentUser;

  // ==================== GET USER PROFILE ====================
  Future<UserModel?> getUserProfile() async {
    try {
      final user = currentUser;
      if (user == null) return null;

      final response = await _client
          .from('users')
          .select()
          .eq('email', user.email!)
          .maybeSingle();

      if (response == null) return null;
      return UserModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  // ==================== UPDATE PROFILE ====================
  Future<void> updateProfile({
    String? namaLengkap,
    String? nomorHp,
    String? alamat,
    String? fotoProfil,
  }) async {
    try {
      final user = currentUser;
      if (user == null) throw Exception('User belum login');

      final updates = <String, dynamic>{};
      if (namaLengkap != null) updates['nama_lengkap'] = namaLengkap;
      if (nomorHp != null) updates['nomor_hp'] = nomorHp;
      if (alamat != null) updates['alamat'] = alamat;
      if (fotoProfil != null) updates['foto_profil'] = fotoProfil;

      await _client
          .from('users')
          .update(updates)
          .eq('email', user.email!);
    } catch (e) {
      throw Exception('Gagal update profile: $e');
    }
  }

  // ==================== FORGOT PASSWORD ====================
  Future<void> forgotPassword(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Gagal mengirim email reset: $e');
    }
  }
}