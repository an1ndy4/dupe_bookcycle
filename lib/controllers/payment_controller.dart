
import 'package:flutter/material.dart';

import '../models/payment_model.dart';
import '../services/payment_service.dart';

class PaymentController extends ChangeNotifier {
  final PaymentService _paymentService = PaymentService();

  PaymentModel? _payment;
  bool _isLoading = false;
  String? _errorMessage;

  // ==================== GETTERS ====================

  PaymentModel? get payment => _payment;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  // ==================== CREATE PAYMENT ====================

  Future<bool> createPayment(PaymentModel payment) async {
    _setLoading(true);
    _clearError();

    try {
      _payment = await _paymentService.createPayment(payment);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ==================== FETCH PAYMENT ====================

  Future<void> fetchPayment(int transaksiId) async {
    _setLoading(true);
    _clearError();

    try {
      _payment = await _paymentService
          .getPaymentByTransactionId(transaksiId);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // ==================== UPDATE PAYMENT STATUS ====================

  Future<bool> updatePaymentStatus({
    required int pembayaranId,
    required String statusPembayaran,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      _payment = await _paymentService.updatePaymentStatus(
        pembayaranId: pembayaranId,
        statusPembayaran: statusPembayaran,
      );
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ==================== UPDATE PAYMENT PROOF ====================

  Future<bool> updatePaymentProof({
    required int pembayaranId,
    required String buktiPembayaran,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      _payment = await _paymentService.updatePaymentProof(
        pembayaranId: pembayaranId,
        buktiPembayaran: buktiPembayaran,
      );
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ==================== RESET PAYMENT ====================

  void resetPayment() {
    _payment = null;
    _clearError();
    notifyListeners();
  }

  // ==================== HELPERS ====================

  void clearError() {
    _clearError();
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }
}
