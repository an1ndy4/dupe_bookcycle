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

  // ==================== GETTERS ====================

  List<CartModel> get cartItems => _cartItems;

  List<CartDetailModel> get cartDetails => _cartDetails;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  bool get isEmpty => _cartItems.isEmpty;

  // ==================== GET USER CART ====================

  Future<void> fetchCart(int userId) async {
    _setLoading(true);
    _clearError();

    try {
      _cartItems = await _cartService.getUserCart(userId);

      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  // ==================== GET CART DETAILS ====================

  Future<void> fetchCartDetails(int keranjangId) async {
    _setLoading(true);
    _clearError();

    try {
      _cartDetails =
          await _cartService.getCartDetails(keranjangId);

      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  // ==================== ADD TO CART ====================

  Future<bool> addToCart({
    required int userId,
    required int bukuId,
    int jumlah = 1,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final newItem = await _cartService.addToCart(
        userId: userId,
        bukuId: bukuId,
        jumlah: jumlah,
      );

      final index = _cartItems.indexWhere(
        (item) => item.keranjangId == newItem.keranjangId,
      );

      if (index != -1) {
        _cartItems[index] = newItem;
      } else {
        _cartItems.insert(0, newItem);
      }

      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // ==================== UPDATE QUANTITY ====================

  Future<bool> updateQuantity({
    required int keranjangId,
    required int jumlah,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final updatedItem =
          await _cartService.updateCartQuantity(
        keranjangId: keranjangId,
        jumlah: jumlah,
      );

      final index = _cartItems.indexWhere(
        (item) => item.keranjangId == keranjangId,
      );

      if (index != -1) {
        _cartItems[index] = updatedItem;
      }

      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // ==================== REMOVE FROM CART ====================

  Future<bool> removeFromCart(int keranjangId) async {
    _setLoading(true);
    _clearError();

    try {
      await _cartService.removeFromCart(keranjangId);

      _cartItems.removeWhere(
        (item) => item.keranjangId == keranjangId,
      );

      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
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

      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // ==================== ADD CART DETAIL ====================

  Future<bool> addCartDetail({
    required int keranjangId,
    required int bukuId,
    required int jumlah,
    required int subtotal,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final detail = await _cartService.addCartDetail(
        keranjangId: keranjangId,
        bukuId: bukuId,
        jumlah: jumlah,
        subtotal: subtotal,
      );

      _cartDetails.insert(0, detail);

      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // ==================== UPDATE CART DETAIL ====================

  Future<bool> updateCartDetail({
    required int detailId,
    required int jumlah,
    required int subtotal,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final updatedDetail =
          await _cartService.updateCartDetail(
        detailId: detailId,
        jumlah: jumlah,
        subtotal: subtotal,
      );

      final index = _cartDetails.indexWhere(
        (detail) => detail.detailId == detailId,
      );

      if (index != -1) {
        _cartDetails[index] = updatedDetail;
      }

      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // ==================== DELETE CART DETAIL ====================

  Future<bool> deleteCartDetail(int detailId) async {
    _setLoading(true);
    _clearError();

    try {
      await _cartService.deleteCartDetail(detailId);

      _cartDetails.removeWhere(
        (detail) => detail.detailId == detailId,
      );

      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
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