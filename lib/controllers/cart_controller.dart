import 'package:flutter/material.dart';

import '../models/cart_model.dart';
import '../models/cart_detail_model.dart';
import '../services/cart_service.dart';

class CartController extends ChangeNotifier {
  final CartService _cartService = CartService();

  List<CartModel> _cartItems = [];
  List<CartDetailModel> _cartDetails = [];

  bool _isLoading = false;
  String? _errorMessage;

  List<CartModel> get cartItems => List.unmodifiable(_cartItems);
  List<CartDetailModel> get cartDetails =>
      List.unmodifiable(_cartDetails);

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isEmpty => _cartItems.isEmpty;

  // ==================== FETCH CART ====================

  Future<void> fetchCart(int userId) async {
    _setLoading(true);
    _clearError();

    try {
      _cartItems = await _cartService.getCart(userId);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // ==================== FETCH CART DETAILS ====================

  Future<void> fetchCartDetails(int userId) async {
    _setLoading(true);
    _clearError();

    try {
      _cartDetails = await _cartService.getCartDetails(userId);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // ==================== ADD TO CART ====================

  Future<bool> addToCart({
    required int userId,
    required int bukuId,
    required int harga,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      await _cartService.addToCart(
        userId: userId,
        bukuId: bukuId,
        harga: harga,
      );

      // Muat ulang agar state sesuai database.
      _cartItems = await _cartService.getCart(userId);
      _cartDetails = await _cartService.getCartDetails(userId);

      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ==================== UPDATE QUANTITY ====================

  Future<bool> updateQuantity({
    required int userId,
    required int bukuId,
    required int jumlah,
    required int harga,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      await _cartService.updateQuantity(
        userId: userId,
        bukuId: bukuId,
        jumlah: jumlah,
        harga: harga,
      );

      _cartItems = await _cartService.getCart(userId);
      _cartDetails = await _cartService.getCartDetails(userId);

      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ==================== REMOVE FROM CART ====================

  Future<bool> removeFromCart({
    required int userId,
    required int bukuId,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      await _cartService.removeFromCart(
        userId: userId,
        bukuId: bukuId,
      );

      _cartItems.removeWhere((item) => item.bukuId == bukuId);
      _cartDetails.removeWhere((item) => item.bukuId == bukuId);

      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ==================== CLEAR CART ====================

  Future<bool> clearCart(int userId) async {
    _setLoading(true);
    _clearError();

    try {
      await _cartService.clearCart(userId);

      _cartItems.clear();
      _cartDetails.clear();

      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
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