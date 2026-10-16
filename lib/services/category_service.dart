import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/category_model.dart';
import 'supabase_service.dart';

class CategoryService {
  final SupabaseClient _client = SupabaseService.client;

  Future<List<CategoryModel>> getAllCategories() async {
    try {
      final response = await _client
          .from('kategori')
          .select()
          .order('kategori_id', ascending: true);

      return response.map((json) => CategoryModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Gagal mengambil kategori: $e');
    }
  }
}