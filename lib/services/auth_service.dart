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
      // 1. Daftar ke Supabase Auth. 
      // Password otomatis di-hash dan diamankan oleh Supabase di tabel auth.users.
      // Data di dalam map 'data' akan ditangkap oleh Trigger database kita 
      // untuk otomatis di-insert ke tabel public.users (TANPA password).
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {
          'nama_lengkap': namaLengkap,
          'nomor_hp': nomorHp ?? '',
          'alamat': alamat ?? '', // Ditambahkan agar trigger bisa menangkapnya
        },
      );

      return response;
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Terjadi kesalahan saat mendaftar: $e');
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
      throw Exception('Terjadi kesalahan saat login: $e');
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

      // PERBAIKAN: Query menggunakan 'auth_id' (UUID) lebih aman dan akurat 
      // daripada menggunakan 'email', karena email bisa saja diubah user nanti.
      final response = await _client
          .from('users')
          .select()
          .eq('auth_id', user.id) 
          .maybeSingle();

      if (response == null) return null;
      return UserModel.fromJson(response);
    } catch (e) {
      print('Error mendapatkan profil user: $e');
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

      if (updates.isEmpty) return; // Jika tidak ada yang diubah, batal request

      // PERBAIKAN: Update menggunakan 'auth_id' agar sesuai dengan relasi database
      await _client
          .from('users')
          .update(updates)
          .eq('auth_id', user.id);
          
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