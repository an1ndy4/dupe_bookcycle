import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/cart_model.dart';
import '../models/cart_detail_model.dart';
import 'supabase_service.dart';

class CartService {
  final SupabaseClient _client = SupabaseService.client;

  // ==================== GET USER CART ====================

  Future<List<CartModel>> getUserCart(int userId) async {
    try {
      final response = await _client
          .from('keranjang')
          .select()
          .eq('user_id', userId)
          .order('keranjang_id', ascending: false);

      return response
          .map<CartModel>((json) => CartModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Gagal mengambil keranjang: $e');
    }
  }

  // ==================== GET CART DETAIL ====================

  Future<List<CartDetailModel>> getCartDetails(int keranjangId) async {
    try {
      final response = await _client
          .from('detail_keranjang')
          .select()
          .eq('keranjang_id', keranjangId)
          .order('detail_id', ascending: false);

      return response
          .map<CartDetailModel>(
            (json) => CartDetailModel.fromJson(json),
          )
          .toList();
    } catch (e) {
      throw Exception('Gagal mengambil detail keranjang: $e');
    }
  }

  // ==================== ADD TO CART ====================

  Future<CartModel> addToCart({
    required int userId,
    required int bukuId,
    int jumlah = 1,
  }) async {
    try {
      final existing = await _client
          .from('keranjang')
          .select()
          .eq('user_id', userId)
          .eq('buku_id', bukuId)
          .maybeSingle();

      if (existing != null) {
        final jumlahLama = existing['jumlah'] as int;

        final response = await _client
            .from('keranjang')
            .update({
              'jumlah': jumlahLama + jumlah,
            })
            .eq('keranjang_id', existing['keranjang_id'])
            .select()
            .single();

        return CartModel.fromJson(response);
      }

      final response = await _client
          .from('keranjang')
          .insert({
            'user_id': userId,
            'buku_id': bukuId,
            'jumlah': jumlah,
          })
          .select()
          .single();

      return CartModel.fromJson(response);
    } catch (e) {
      throw Exception('Gagal menambahkan buku ke keranjang: $e');
    }
  }

  // ==================== UPDATE CART QUANTITY ====================

  Future<CartModel> updateCartQuantity({
    required int keranjangId,
    required int jumlah,
  }) async {
    if (jumlah < 1) {
      throw Exception('Jumlah buku minimal 1');
    }

    try {
      final response = await _client
          .from('keranjang')
          .update({
            'jumlah': jumlah,
          })
          .eq('keranjang_id', keranjangId)
          .select()
          .single();

      return CartModel.fromJson(response);
    } catch (e) {
      throw Exception('Gagal mengubah jumlah buku: $e');
    }
  }

  // ==================== REMOVE FROM CART ====================

  Future<void> removeFromCart(int keranjangId) async {
    try {
      await _client
          .from('keranjang')
          .delete()
          .eq('keranjang_id', keranjangId);
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

  // ==================== ADD CART DETAIL ====================

  Future<CartDetailModel> addCartDetail({
    required int keranjangId,
    required int bukuId,
    required int jumlah,
    required int subtotal,
  }) async {
    try {
      final response = await _client
          .from('detail_keranjang')
          .insert({
            'keranjang_id': keranjangId,
            'buku_id': bukuId,
            'jumlah': jumlah,
            'subtotal': subtotal,
          })
          .select()
          .single();

      return CartDetailModel.fromJson(response);
    } catch (e) {
      throw Exception('Gagal menambahkan detail keranjang: $e');
    }
  }

  // ==================== UPDATE CART DETAIL ====================

  Future<CartDetailModel> updateCartDetail({
    required int detailId,
    required int jumlah,
    required int subtotal,
  }) async {
    if (jumlah < 1) {
      throw Exception('Jumlah buku minimal 1');
    }

    try {
      final response = await _client
          .from('detail_keranjang')
          .update({
            'jumlah': jumlah,
            'subtotal': subtotal,
          })
          .eq('detail_id', detailId)
          .select()
          .single();

      return CartDetailModel.fromJson(response);
    } catch (e) {
      throw Exception('Gagal mengubah detail keranjang: $e');
    }
  }

  // ==================== DELETE CART DETAIL ====================

  Future<void> deleteCartDetail(int detailId) async {
    try {
      await _client
          .from('detail_keranjang')
          .delete()
          .eq('detail_id', detailId);
    } catch (e) {
      throw Exception('Gagal menghapus detail keranjang: $e');
    }
  }
}