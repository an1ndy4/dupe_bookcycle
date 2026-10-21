import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/book_model.dart';
import 'supabase_service.dart';

class BookService {
  final SupabaseClient _client = SupabaseService.client;

  // ==================== GET ALL BOOKS ====================
  Future<List<BookModel>> getAllBooks() async {
    try {
      final response = await _client
          .from('buku')
          .select()
          .eq('status_buku', 'Tersedia')
          .order('buku_id', ascending: false);

      return response
          .map<BookModel>((json) => BookModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Gagal mengambil data buku: $e');
    }
  }

  // ==================== GET BOOK BY ID ====================
  Future<BookModel?> getBookById(int bukuId) async {
    try {
      final response = await _client
          .from('buku')
          .select()
          .eq('buku_id', bukuId)
          .maybeSingle();

      if (response == null) {
        return null;
      }

      return BookModel.fromJson(response);
    } catch (e) {
      throw Exception('Gagal mengambil detail buku: $e');
    }
  }

  // ==================== GET BOOKS BY CATEGORY ====================
  Future<List<BookModel>> getBooksByCategory(int kategoriId) async {
    try {
      final response = await _client
          .from('buku')
          .select()
          .eq('kategori_id', kategoriId)
          .eq('status_buku', 'Tersedia')
          .order('buku_id', ascending: false);

      return response
          .map<BookModel>((json) => BookModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Gagal mengambil buku berdasarkan kategori: $e');
    }
  }

  // ==================== GET BOOKS FOR SALE ====================
  Future<List<BookModel>> getBooksForSale() async {
    try {
      final response = await _client
          .from('buku')
          .select()
          .eq('jenis_transaksi', 'Jual')
          .eq('status_buku', 'Tersedia')
          .order('buku_id', ascending: false);

      return response
          .map<BookModel>((json) => BookModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Gagal mengambil buku untuk dijual: $e');
    }
  }

  // ==================== GET BOOKS FOR EXCHANGE ====================
  // ==================== GET BOOKS FOR EXCHANGE ====================
  Future<List<BookModel>> getBooksForExchange() async {
    try {
      final response = await _client
          .from('buku')
          .select()
          .inFilter('jenis_transaksi', ['Tukar', 'Jual_Tukar'])
          .eq('status_buku', 'Tersedia')
          .order('buku_id', ascending: false);

      return response
          .map<BookModel>((json) => BookModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Gagal mengambil buku untuk ditukar: $e');
    }
  }

  // ==================== SEARCH BOOKS ====================
  Future<List<BookModel>> searchBooks(String query) async {
    try {
      final response = await _client
          .from('buku')
          .select()
          .ilike('judul_buku', '%$query%')
          .eq('status_buku', 'Tersedia')
          .order('buku_id', ascending: false);

      return response
          .map<BookModel>((json) => BookModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Gagal mencari buku: $e');
    }
  }


  // ==================== INSERT BOOK ====================
  Future<BookModel> insertBook(BookModel book) async {
    try {
      final authUser = _client.auth.currentUser;

      if (authUser == null) {
        throw Exception('Pengguna belum login.');
      }

      // Cari profil pengguna berdasarkan UUID Supabase Auth.
      final profile = await _client
          .from('users')
          .select('user_id')
          .eq('auth_id', authUser.id)
          .maybeSingle();

      if (profile == null) {
        throw Exception(
          'Profil pengguna tidak ditemukan. '
          'Periksa hubungan akun dengan tabel users.',
        );
      }

      // Siapkan data untuk tabel public.buku.
      final payload = book.toJson();

      // Biarkan database menghasilkan ID otomatis.
      if (payload['buku_id'] == null) {
        payload.remove('buku_id');
      }

      // Gunakan ID internal, bukan UUID Supabase Auth.
      payload['user_id'] = profile['user_id'];

      // Simpan dan ambil kembali data yang berhasil dimasukkan.
      final response = await _client
          .from('buku')
          .insert(payload)
          .select()
          .single();

      return BookModel.fromJson(response);
    } catch (e) {
      throw Exception('Gagal menambahkan buku: $e');
    }
  }


  // ==================== UPDATE BOOK ====================
  Future<BookModel> updateBook(
    int bukuId,
    Map<String, dynamic> updates,
  ) async {
    try {
      final response = await _client
          .from('buku')
          .update(updates)
          .eq('buku_id', bukuId)
          .select()
          .single();

      return BookModel.fromJson(response);
    } catch (e) {
      throw Exception('Gagal mengupdate buku: $e');
    }
  }

  // ==================== DELETE BOOK ====================
  Future<void> deleteBook(int bukuId) async {
    try {
      await _client
          .from('buku')
          .delete()
          .eq('buku_id', bukuId);
    } catch (e) {
      throw Exception('Gagal menghapus buku: $e');
    }
  }

  // ==================== GET MY BOOKS ====================
  Future<List<BookModel>> getMyBooks(int userId) async {
    try {
      final response = await _client
          .from('buku')
          .select()
          .eq('user_id', userId)
          .order('buku_id', ascending: false);

      return response
          .map<BookModel>((json) => BookModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Gagal mengambil buku milik pengguna: $e');
    }
  }
}