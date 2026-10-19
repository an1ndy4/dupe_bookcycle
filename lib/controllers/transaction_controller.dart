
import 'package:flutter/material.dart';

import '../models/transaction_model.dart';
import '../models/transaction_detail_model.dart';
import '../services/transaction_service.dart';

class TransactionController extends ChangeNotifier {
  final TransactionService _transactionService = TransactionService();

  List<TransactionModel> _transactions = [];
  List<TransactionDetailModel> _transactionDetails = [];

  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _checkoutResult;

  // ==================== GETTERS ====================

  List<TransactionModel> get transactions =>
      List.unmodifiable(_transactions);

  List<TransactionDetailModel> get transactionDetails =>
      List.unmodifiable(_transactionDetails);

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  Map<String, dynamic>? get checkoutResult => _checkoutResult;

  // ==================== CHECKOUT VIA RPC ====================

  Future<Map<String, dynamic>?> checkoutBookcycle({
    required String alamatPengiriman,
    required String metodePembayaran,
  }) async {
    _setLoading(true);
    _clearError();
    _checkoutResult = null;

    try {
      if (alamatPengiriman.trim().isEmpty) {
        throw Exception('Alamat pengiriman wajib diisi');
      }

      if (metodePembayaran.trim().isEmpty) {
        throw Exception('Metode pembayaran wajib dipilih');
      }

      final result = await _transactionService.checkoutBookcycle(
        alamatPengiriman: alamatPengiriman.trim(),
        metodePembayaran: metodePembayaran,
      );

      _checkoutResult = result;

      final rawId = result['transaksi_id'];
      final transaksiId = rawId is num ? rawId.toInt() : null;

      if (transaksiId == null) {
        throw Exception('ID transaksi tidak ditemukan pada hasil checkout');
      }

      // Muat transaksi yang baru dibuat.
      final transaction =
          await _transactionService.getTransactionById(transaksiId);

      if (transaction != null) {
        _transactions.removeWhere(
          (item) => item.transaksiId == transaksiId,
        );
        _transactions.insert(0, transaction);
      }

      // Muat detail transaksi yang sudah tersimpan.
      _transactionDetails =
          await _transactionService.getTransactionDetails(transaksiId);

      return result;
    } catch (e) {
      _setError(e.toString());
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // ==================== LEGACY CREATE TRANSACTION ====================

  // Pertahankan untuk kompatibilitas dengan pemanggil lama.
  // Untuk checkout baru, gunakan checkoutBookcycle().

  Future<TransactionModel?> createTransaction({
    required TransactionModel transaction,
    required List<TransactionDetailModel> details,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      if (details.isEmpty) {
        throw Exception('Detail transaksi tidak boleh kosong');
      }

      final createdTransaction =
          await _transactionService.createTransaction(transaction);

      final transaksiId = createdTransaction.transaksiId;

      if (transaksiId == null) {
        throw Exception('ID transaksi tidak ditemukan');
      }

      final linkedDetails = details.map((detail) {
        return detail.copyWith(transaksiId: transaksiId);
      }).toList();

      final savedDetails = await _transactionService
          .createTransactionDetails(linkedDetails);

      _transactions.insert(0, createdTransaction);
      _transactionDetails = savedDetails;

      return createdTransaction;
    } catch (e) {
      _setError(e.toString());
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // ==================== FETCH USER TRANSACTIONS ====================

  Future<void> fetchUserTransactions(int userId) async {
    _setLoading(true);
    _clearError();

    try {
      _transactions =
          await _transactionService.getUserTransactions(userId);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // ==================== FETCH TRANSACTION BY ID ====================

  Future<TransactionModel?> fetchTransactionById(
    int transaksiId,
  ) async {
    _setLoading(true);
    _clearError();

    try {
      return await _transactionService.getTransactionById(transaksiId);
    } catch (e) {
      _setError(e.toString());
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // ==================== FETCH TRANSACTION DETAILS ====================

  Future<void> fetchTransactionDetails(int transaksiId) async {
    _setLoading(true);
    _clearError();

    try {
      _transactionDetails =
          await _transactionService.getTransactionDetails(transaksiId);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // ==================== UPDATE TRANSACTION STATUS ====================

  Future<bool> updateTransactionStatus({
    required int transaksiId,
    required String status,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final updatedTransaction =
          await _transactionService.updateTransactionStatus(
        transaksiId: transaksiId,
        status: status,
      );

      final index = _transactions.indexWhere(
        (item) => item.transaksiId == transaksiId,
      );

      if (index != -1) {
        _transactions[index] = updatedTransaction;
      }

      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ==================== RESET CHECKOUT RESULT ====================

  void resetCheckoutResult() {
    _checkoutResult = null;
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
