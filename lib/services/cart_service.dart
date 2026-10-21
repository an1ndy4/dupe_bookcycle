
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/cart_model.dart';
import '../models/cart_detail_model.dart';
import 'supabase_service.dart';

class CartService {
  final SupabaseClient _client = SupabaseService.client;

  // ==================== GET CART ====================

  Future<List<CartModel>> getCart(int userId) async {
    try {
      final response = await _client
          .from('keranjang')
          .select()
          .eq('user_id', userId)
          .order('tanggal_dibuat', ascending: false);

      return response
          .map<CartModel>((json) => CartModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Gagal mengambil keranjang: $e');
    }
  }

  // ==================== GET CART DETAILS ====================

  Future<List<CartDetailModel>> getCartDetails(int userId) async {
    try {
      final response = await _client
          .from('keranjang')
          .select('''
            keranjang_id,
            buku_id,
            jumlah,
            buku (
              harga
            )
          ''')
          .eq('user_id', userId);

      return response.map<CartDetailModel>((json) {
        final book = json['buku'];

        final harga = book is Map
            ? (book['harga'] as num?)?.toInt() ?? 0
            : 0;

        final jumlah = (json['jumlah'] as num).toInt();

        return CartDetailModel(
          keranjangId: (json['keranjang_id'] as num).toInt(),
          bukuId: (json['buku_id'] as num).toInt(),
          jumlah: jumlah,
          subtotal: harga * jumlah,
        );
      }).toList();
    } catch (e) {
      throw Exception('Gagal mengambil detail keranjang: $e');
    }
  }

  // ==================== ADD TO CART ====================

  Future<void> addToCart({
    required int userId,
    required int bukuId,
    required int harga,
  }) async {
    try {
      final existingCart = await _client
          .from('keranjang')
          .select('keranjang_id, jumlah')
          .eq('user_id', userId)
          .eq('buku_id', bukuId)
          .maybeSingle();

      if (existingCart == null) {
        await _client.from('keranjang').insert({
          'user_id': userId,
          'buku_id': bukuId,
          'jumlah': 1,
        });
      } else {
        final cartId =
            (existingCart['keranjang_id'] as num).toInt();

        final jumlahLama =
            (existingCart['jumlah'] as num).toInt();

        await _client
            .from('keranjang')
            .update({'jumlah': jumlahLama + 1})
            .eq('keranjang_id', cartId)
            .eq('user_id', userId);
      }
    } catch (e) {
      throw Exception('Gagal menambahkan buku ke keranjang: $e');
    }
  }

  // ==================== UPDATE QUANTITY ====================

  Future<void> updateQuantity({
    required int userId,
    required int bukuId,
    required int jumlah,
    required int harga,
  }) async {
    try {
      if (jumlah <= 0) {
        await removeFromCart(
          userId: userId,
          bukuId: bukuId,
        );
        return;
      }

      final response = await _client
          .from('keranjang')
          .update({'jumlah': jumlah})
          .eq('user_id', userId)
          .eq('buku_id', bukuId)
          .select('keranjang_id');

      if (response.isEmpty) {
        throw Exception('Buku tidak ditemukan di keranjang');
      }
    } catch (e) {
      throw Exception('Gagal mengubah jumlah buku: $e');
    }
  }

  // ==================== REMOVE FROM CART ====================

  Future<void> removeFromCart({
    required int userId,
    required int bukuId,
  }) async {
    try {
      await _client
          .from('keranjang')
          .delete()
          .eq('user_id', userId)
          .eq('buku_id', bukuId);
    } catch (e) {
      throw Exception('Gagal menghapus buku dari keranjang: $e');
    }
  }

  // ==================== CLEAR CART ====================

  Future<void> clearCart(int userId) async {
    try {
      await _client
          .from('keranjang')
          .delete()
          .eq('user_id', userId);
    } catch (e) {
      throw Exception('Gagal mengosongkan keranjang: $e');
    }
  }
}
