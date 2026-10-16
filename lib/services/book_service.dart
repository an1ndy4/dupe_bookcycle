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

      return response.map((json) => BookModel.fromJson(json)).toList();
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
          .single();

      return BookModel.fromJson(response);
    } catch (e) {
      return null;
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

      return response.map((json) => BookModel.fromJson(json)).toList();
    } catch (e) {
      return [];
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

      return response.map((json) => BookModel.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  // ==================== GET BOOKS FOR EXCHANGE ====================
  Future<List<BookModel>> getBooksForExchange() async {
    try {
      final response = await _client
          .from('buku')
          .select()
          .eq('jenis_transaksi', 'Tukar')
          .eq('status_buku', 'Tersedia')
          .order('buku_id', ascending: false);

      return response.map((json) => BookModel.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  // ==================== SEARCH BOOKS ====================
  Future<List<BookModel>> searchBooks(String query) async {
    try {
      final response = await _client
          .from('buku')
          .select()
          .ilike('judul_buku', '%$query%')
          .eq('status_buku', 'Tersedia');

      return response.map((json) => BookModel.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  // ==================== INSERT BOOK ====================
  Future<BookModel> insertBook(BookModel book) async {
    try {
      final response = await _client
          .from('buku')
          .insert(book.toJson())
          .select()
          .single();

      return BookModel.fromJson(response);
    } catch (e) {
      throw Exception('Gagal menambahkan buku: $e');
    }
  }

  // ==================== UPDATE BOOK ====================
  Future<BookModel> updateBook(int bukuId, Map<String, dynamic> updates) async {
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

      return response.map((json) => BookModel.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }
}