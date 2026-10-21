
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/transaction_model.dart';
import '../models/transaction_detail_model.dart';
import 'supabase_service.dart';

class TransactionService {
  final SupabaseClient _client = SupabaseService.client;

  // ==================== CHECKOUT VIA RPC ====================

  Future<Map<String, dynamic>> checkoutBookcycle({
    required String alamatPengiriman,
    required String metodePembayaran,
  }) async {
    try {
      final response = await _client.rpc(
        'checkout_bookcycle',
        params: {
          'p_alamat_pengiriman': alamatPengiriman,
          'p_metode_pembayaran': metodePembayaran,
        },
      );

      if (response is! Map) {
        throw Exception('Respons checkout dari server tidak valid');
      }

      final result = Map<String, dynamic>.from(response);

      if (result['success'] != true) {
        throw Exception('Checkout tidak berhasil');
      }

      return result;
    } on PostgrestException catch (e) {
      throw Exception('Checkout gagal: ${e.message}');
    } catch (e) {
      throw Exception('Gagal memproses checkout: $e');
    }
  }

  // ==================== CREATE TRANSACTION ====================

  Future<TransactionModel> createTransaction(
    TransactionModel transaction,
  ) async {
    try {
      final data = transaction.toJson();

      if (transaction.transaksiId != null) {
        data['transaksi_id'] = transaction.transaksiId;
      }

      final response = await _client
          .from('transaksi')
          .insert(data)
          .select()
          .single();

      return TransactionModel.fromJson(response);
    } catch (e) {
      throw Exception('Gagal membuat transaksi: $e');
    }
  }

  // ==================== GET USER TRANSACTIONS ====================

  Future<List<TransactionModel>> getUserTransactions(
    int userId,
  ) async {
    try {
      final response = await _client
          .from('transaksi')
          .select()
          .eq('user_id', userId)
          .order('tanggal_dibuat', ascending: false);

      return response
          .map<TransactionModel>(
            (json) => TransactionModel.fromJson(json),
          )
          .toList();
    } catch (e) {
      throw Exception('Gagal mengambil riwayat transaksi: $e');
    }
  }

  // ==================== GET TRANSACTION BY ID ====================

  Future<TransactionModel?> getTransactionById(
    int transaksiId,
  ) async {
    try {
      final response = await _client
          .from('transaksi')
          .select()
          .eq('transaksi_id', transaksiId)
          .maybeSingle();

      if (response == null) return null;

      return TransactionModel.fromJson(response);
    } catch (e) {
      throw Exception('Gagal mengambil detail transaksi: $e');
    }
  }

  // ==================== UPDATE TRANSACTION STATUS ====================

  Future<TransactionModel> updateTransactionStatus({
    required int transaksiId,
    required String status,
  }) async {
    try {
      final response = await _client
          .from('transaksi')
          .update({'status': status})
          .eq('transaksi_id', transaksiId)
          .select()
          .single();

      return TransactionModel.fromJson(response);
    } catch (e) {
      throw Exception('Gagal memperbarui status transaksi: $e');
    }
  }

  // ==================== CREATE TRANSACTION DETAILS ====================

  Future<List<TransactionDetailModel>> createTransactionDetails(
    List<TransactionDetailModel> details,
  ) async {
    if (details.isEmpty) {
      throw Exception('Detail transaksi tidak boleh kosong');
    }

    try {
      final data = details.map((detail) => detail.toJson()).toList();

      final response = await _client
          .from('detail_transaksi')
          .insert(data)
          .select();

      return response
          .map<TransactionDetailModel>(
            (json) => TransactionDetailModel.fromJson(json),
          )
          .toList();
    } catch (e) {
      throw Exception('Gagal menyimpan detail transaksi: $e');
    }
  }

  // ==================== GET TRANSACTION DETAILS ====================

  Future<List<TransactionDetailModel>> getTransactionDetails(
    int transaksiId,
  ) async {
    try {
      final response = await _client
          .from('detail_transaksi')
          .select()
          .eq('transaksi_id', transaksiId)
          .order('detail_id', ascending: true);

      return response
          .map<TransactionDetailModel>(
            (json) => TransactionDetailModel.fromJson(json),
          )
          .toList();
    } catch (e) {
      throw Exception('Gagal mengambil detail transaksi: $e');
    }
  }
}
