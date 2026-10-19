import 'package:flutter/material.dart';

import '../models/book_model.dart';
import '../services/book_service.dart';

class BookController extends ChangeNotifier {
  final BookService _bookService = BookService();

  List<BookModel> _books = [];
  List<BookModel> _filteredBooks = [];

  bool _isLoading = false;
  String? _errorMessage;

  String _searchQuery = '';
  int _selectedCategoryId = 0;

  // ==================== GETTERS ====================

  List<BookModel> get books => _filteredBooks;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  String get searchQuery => _searchQuery;

  int get selectedCategoryId => _selectedCategoryId;

  // ==================== FETCH ALL BOOKS ====================

  Future<void> fetchAllBooks() async {
    _setLoading(true);
    _clearError();

    try {
      _books = await _bookService.getAllBooks();

      _searchQuery = '';
      _selectedCategoryId = 0;

      _filteredBooks = List.from(_books);

      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  // ==================== FETCH BOOKS BY CATEGORY ====================

  Future<void> fetchBooksByCategory(int kategoriId) async {
    _setLoading(true);
    _clearError();

    try {
      _books = await _bookService.getBooksByCategory(kategoriId);

      _selectedCategoryId = kategoriId;
      _searchQuery = '';

      _filteredBooks = List.from(_books);

      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  // ==================== SEARCH BOOKS ====================

  Future<void> searchBooks(String query) async {
    _searchQuery = query.trim();

    if (_searchQuery.isEmpty) {
      _filteredBooks = List.from(_books);
      _clearError();
      notifyListeners();
      return;
    }

    _setLoading(true);
    _clearError();

    try {
      final results = await _bookService.searchBooks(_searchQuery);

      _filteredBooks = results;

      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  // ==================== FILTER BY CATEGORY ====================

  Future<void> filterByCategory(int kategoriId) async {
    _selectedCategoryId = kategoriId;

    if (kategoriId == 0) {
      await fetchAllBooks();
      return;
    }

    await fetchBooksByCategory(kategoriId);
  }

  // ==================== ADD BOOK ====================

  Future<bool> addBook(BookModel book) async {
    _setLoading(true);
    _clearError();

    try {
      final newBook = await _bookService.insertBook(book);

      _books.insert(0, newBook);
      _filteredBooks = List.from(_books);

      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // ==================== UPDATE BOOK ====================

  Future<bool> updateBook(int bukuId, Map<String, dynamic> updates) async {
    _setLoading(true);
    _clearError();

    try {
      final updatedBook = await _bookService.updateBook(bukuId, updates);

      final index = _books.indexWhere((book) => book.bukuId == bukuId);

      if (index != -1) {
        _books[index] = updatedBook;
      }

      _filteredBooks = List.from(_books);

      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // ==================== DELETE BOOK ====================

  Future<bool> deleteBook(int bukuId) async {
    _setLoading(true);
    _clearError();

    try {
      await _bookService.deleteBook(bukuId);

      _books.removeWhere((book) => book.bukuId == bukuId);

      _filteredBooks.removeWhere((book) => book.bukuId == bukuId);

      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // ==================== GET BOOK BY ID ====================

  Future<BookModel?> getBookById(int bukuId) async {
    try {
      return await _bookService.getBookById(bukuId);
    } catch (e) {
      _setError(e.toString());
      return null;
    }
  }

  // ==================== GET MY BOOKS ====================

  Future<List<BookModel>> getMyBooks(int userId) async {
    _setLoading(true);
    _clearError();

    try {
      final books = await _bookService.getMyBooks(userId);

      _setLoading(false);
      return books;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return [];
    }
  }

  // ==================== CLEAR SEARCH ====================

  void clearSearch() {
    _searchQuery = '';
    _filteredBooks = List.from(_books);

    _clearError();
    notifyListeners();
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
