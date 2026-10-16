import 'package:flutter/material.dart';

import '../models/category_model.dart';
import '../services/category_service.dart';

class CategoryController extends ChangeNotifier {
  final CategoryService _categoryService = CategoryService();

  List<CategoryModel> _categories = [];

  // ✅ 1. TAMBAHKAN VARIABEL INI (Default 0 artinya kategori 'Semua')
  int _selectedCategoryId = 0;

  bool _isLoading = false;
  String? _errorMessage;

  List<CategoryModel> get categories => _categories;

  // ✅ 2. TAMBAHKAN GETTER INI (Agar bisa dibaca oleh home_screen.dart)
  int get selectedCategoryId => _selectedCategoryId;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchAllCategories() async {
    _isLoading = true;
    notifyListeners();

    try {
      _categories = await _categoryService.getAllCategories();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // ✅ 3. TAMBAHKAN METHOD INI (Agar home_screen bisa mengubah kategori yang dipilih)
  void setSelectedCategory(int id) {
    _selectedCategoryId = id;
    notifyListeners(); // Memberitahu UI untuk update tampilan
  }
}
