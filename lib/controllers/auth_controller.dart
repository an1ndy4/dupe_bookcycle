import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthController extends ChangeNotifier {
  final AuthService _authService = AuthService();

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _currentUser != null;

  // ==================== REGISTER ====================
  Future<bool> register({
    required String email,
    required String password,
    required String namaLengkap,
    String? nomorHp,
    String? alamat,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      await _authService.register(
        email: email,
        password: password,
        namaLengkap: namaLengkap,
        nomorHp: nomorHp,
        alamat: alamat,
      );
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // ==================== LOGIN ====================
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _authService.login(
        email: email,
        password: password,
      );

      if (response.user != null) {
        // Ambil data user dari tabel users
        _currentUser = await _authService.getUserProfile();
        _setLoading(false);
        notifyListeners();
        return true;
      }
      _setLoading(false);
      return false;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // ==================== LOGOUT ====================
  Future<void> logout() async {
    try {
      await _authService.logout();
      _currentUser = null;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    }
  }

  // ==================== LOAD CURRENT USER ====================
  Future<void> loadCurrentUser() async {
    try {
      _currentUser = await _authService.getUserProfile();
      notifyListeners();
    } catch (e) {
      // User belum login
    }
  }

  // ==================== UPDATE PROFILE ====================
  Future<bool> updateProfile({
    String? namaLengkap,
    String? nomorHp,
    String? alamat,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      await _authService.updateProfile(
        namaLengkap: namaLengkap,
        nomorHp: nomorHp,
        alamat: alamat,
      );
      await loadCurrentUser();
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // ==================== FORGOT PASSWORD ====================
  Future<bool> forgotPassword(String email) async {
    _setLoading(true);
    _clearError();

    try {
      await _authService.forgotPassword(email);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // ==================== HELPERS ====================
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