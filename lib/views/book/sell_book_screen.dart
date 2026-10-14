import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SellBookScreen extends StatefulWidget {
  const SellBookScreen({Key? key}) : super(key: key);

  @override
  State<SellBookScreen> createState() => _SellBookScreenState();
}

class _SellBookScreenState extends State<SellBookScreen> {
  final _supabase = Supabase.instance.client;
  final _formKey = GlobalKey<FormState>();
  final _imagePicker = ImagePicker();

  // 🎛️ Controllers
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();

  // 📦 State Variables
  String? _selectedCategory;
  String? _selectedCondition;
  File? _bookImage;
  bool _isUploading = false;

  // 📋 Opsi Dropdown
  final List<String> _categories = [
    'Fiksi',
    'Non Fiksi',
    'Pelajaran',
    'Komik',
    'Self Help',
    'Teknologi',
    'Bisnis',
    'Lainnya',
  ];

  final List<String> _conditions = [
    'Sangat Baik (Seperti Baru)',
    'Baik (Ada sedikit catatan)',
    'Cukup Baik (Ada highlight)',
    'Kurang Baik (Ada sobekan kecil)',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // 📸 Fungsi Pilih Gambar (Kamera / Galeri)
  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _imagePicker.pickImage(
      source: source,
      maxWidth: 1080, // Kompres otomatis agar upload cepat
      maxHeight: 1080,
      imageQuality: 85,
    );

    if (image != null) {
      setState(() => _bookImage = File(image.path));
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Pilih Sumber Foto',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xFF2E7D32)),
              title: const Text('Ambil dari Kamera'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.photo_library,
                color: Color(0xFF2E7D32),
              ),
              title: const Text('Pilih dari Galeri'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  // ☁️ Upload Foto ke Supabase Storage
  Future<String?> _uploadImageToSupabase(File imageFile) async {
    try {
      final userId = _supabase.auth.currentUser!.id;
      final fileName =
          'book_${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final filePath = 'books/$fileName';

      await _supabase.storage.from('book-images').upload(filePath, imageFile);

      return _supabase.storage.from('book-images').getPublicUrl(filePath);
    } catch (e) {
      debugPrint('Error Upload Storage: $e');
      return null;
    }
  }

  // 💾 Submit Data Buku ke Database
  Future<void> _submitBook() async {
    if (!_formKey.currentState!.validate()) return;
    if (_bookImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Foto buku wajib diupload!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isUploading = true);

    try {
      // 1. Upload Foto
      final imageUrl = await _uploadImageToSupabase(_bookImage!);
      if (imageUrl == null)
        throw Exception(
          'Gagal mengupload foto. Cek koneksi atau policy storage.',
        );

      // 2. Parse Harga
      final rawPrice = _priceController.text
          .replaceAll('.', '')
          .replaceAll(',', '');
      final price = int.tryParse(rawPrice);
      if (price == null) throw Exception('Format harga tidak valid.');

      // 3. Insert ke Database
      await _supabase.from('books').insert({
        'user_id': _supabase.auth.currentUser!.id,
        'title': _titleController.text.trim(),
        'author': _authorController.text.trim(),
        'category': _selectedCategory,
        'condition': _selectedCondition,
        'price': price,
        'description': _descriptionController.text.trim(),
        'image_url': imageUrl,
        'is_for_sale': true,
        'is_for_exchange': false,
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Buku berhasil diunggah!'),
          backgroundColor: Color(0xFF2E7D32),
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Gagal: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryGreen = Color(0xFF2E7D32);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Jual Buku',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: _isUploading
          ? const Center(child: CircularProgressIndicator(color: primaryGreen))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🖼️ Area Upload Foto
                    Center(
                      child: GestureDetector(
                        onTap: _isUploading ? null : _showImageSourceDialog,
                        child: Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: _bookImage != null
                                  ? primaryGreen
                                  : Colors.grey[300]!,
                              width: 2,
                              style: BorderStyle.solid,
                            ),
                          ),
                          child: _bookImage != null
                              ? Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(14),
                                      // ✅ PERBAIKAN: Support Web & Mobile
                                      child: kIsWeb
                                          ? Image.memory(
                                              _bookImage!.readAsBytesSync(),
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              height: double.infinity,
                                            )
                                          : Image.file(
                                              _bookImage!,
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              height: double.infinity,
                                            ),
                                    ),
                                    Positioned(
                                      bottom: 10,
                                      right: 10,
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          // ✅ PERBAIKAN: withValues untuk menghindari warning deprecated
                                          color: Colors.black.withValues(
                                            alpha: 0.6,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.edit,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: primaryGreen.withValues(
                                          alpha: 0.1,
                                        ), // ✅ PERBAIKAN
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.camera_alt,
                                        size: 40,
                                        color: primaryGreen,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    const Text(
                                      'Tambah Foto Buku',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Ketuk untuk ambil foto',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 📝 Input Fields
                    _buildTextField(
                      'Judul Buku',
                      _titleController,
                      'Masukkan judul buku',
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      'Penulis',
                      _authorController,
                      'Masukkan nama penulis',
                    ),
                    const SizedBox(height: 16),

                    // 🏷️ Kategori & Kondisi
                    _buildDropdown(
                      'Kategori',
                      _selectedCategory,
                      _categories,
                      'Pilih kategori buku',
                      (val) {
                        setState(() => _selectedCategory = val);
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildDropdown(
                      'Kondisi Buku',
                      _selectedCondition,
                      _conditions,
                      'Pilih kondisi buku',
                      (val) {
                        setState(() => _selectedCondition = val);
                      },
                    ),
                    const SizedBox(height: 16),

                    // 💰 Harga
                    _buildTextField(
                      'Harga Jual',
                      _priceController,
                      'Masukkan harga (contoh: 75000)',
                      isNumber: true,
                      prefix: 'Rp ',
                    ),
                    const SizedBox(height: 16),

                    // 📖 Deskripsi
                    const Text(
                      'Deskripsi',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Ceritakan kondisi buku, tahun terbit, dll',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: primaryGreen,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // 🚀 Tombol Unggah
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isUploading ? null : _submitBook,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryGreen,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: const Text('Unggah Buku'),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }

  // 🛠️ Helper Widget untuk TextField
  Widget _buildTextField(
    String label,
    TextEditingController controller,
    String hint, {
    bool isNumber = false,
    String? prefix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            hintText: hint,
            prefixText: prefix,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
            ),
          ),
          validator: (v) => v!.isEmpty ? '$label wajib diisi' : null,
        ),
      ],
    );
  }

  // 🛠️ Helper Widget untuk Dropdown
  Widget _buildDropdown(
    String label,
    String? value,
    List<String> items,
    String hint,
    Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
            ),
          ),
          items: items
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
          onChanged: onChanged,
          validator: (v) => v == null ? '$label wajib dipilih' : null,
        ),
      ],
    );
  }
}
