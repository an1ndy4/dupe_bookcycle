
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/payment_model.dart';
import 'supabase_service.dart';

class PaymentService {
  final SupabaseClient _client = SupabaseService.client;

  // ==================== CREATE PAYMENT ====================

  Future<PaymentModel> createPayment(PaymentModel payment) async {
    try {
      final data = <String, dynamic>{
        'transaksi_id': payment.transaksiId,
        'metode_pembayaran': payment.metodePembayaran,
        'status_pembayaran': payment.statusPembayaran,
      };

      if (payment.buktiPembayaran != null) {
        data['bukti_pembayaran'] = payment.buktiPembayaran;
      }

      if (payment.tanggalBayar != null) {
        data['tanggal_bayar'] =
            payment.tanggalBayar!.toIso8601String();
      }

      final response = await _client
          .from('pembayaran')
          .insert(data)
          .select()
          .single();

      return PaymentModel.fromJson(response);
    } catch (e) {
      throw Exception('Gagal membuat pembayaran: $e');
    }
  }

  // ==================== GET PAYMENT BY TRANSACTION ====================

  Future<PaymentModel?> getPaymentByTransactionId(
    int transaksiId,
  ) async {
    try {
      final response = await _client
          .from('pembayaran')
          .select()
          .eq('transaksi_id', transaksiId)
          .maybeSingle();

      if (response == null) return null;

      return PaymentModel.fromJson(response);
    } catch (e) {
      throw Exception('Gagal mengambil data pembayaran: $e');
    }
  }

  // ==================== UPDATE PAYMENT STATUS ====================

  Future<PaymentModel> updatePaymentStatus({
    required int pembayaranId,
    required String statusPembayaran,
  }) async {
    try {
      final response = await _client
          .from('pembayaran')
          .update({
            'status_pembayaran': statusPembayaran,
          })
          .eq('pembayaran_id', pembayaranId)
          .select()
          .single();

      return PaymentModel.fromJson(response);
    } catch (e) {
      throw Exception('Gagal memperbarui status pembayaran: $e');
    }
  }

  // ==================== UPDATE PAYMENT PROOF ====================

  Future<PaymentModel> updatePaymentProof({
    required int pembayaranId,
    required String buktiPembayaran,
  }) async {
    try {
      final response = await _client
          .from('pembayaran')
          .update({
            'bukti_pembayaran': buktiPembayaran,
          })
          .eq('pembayaran_id', pembayaranId)
          .select()
          .single();

      return PaymentModel.fromJson(response);
    } catch (e) {
      throw Exception('Gagal menyimpan bukti pembayaran: $e');
    }
  }
}
