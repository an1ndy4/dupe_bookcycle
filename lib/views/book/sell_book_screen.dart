import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../controllers/book_controller.dart';
import '../../models/book_model.dart';

class SellBookScreen extends StatefulWidget {
  const SellBookScreen({Key? key}) : super(key: key);

  @override
  State<SellBookScreen> createState() => _SellBookScreenState();
}

class _SellBookScreenState extends State<SellBookScreen> {
  final SupabaseClient _supabase = Supabase.instance.client;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImagePicker _imagePicker = ImagePicker();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  XFile? _bookImage;
  Uint8List? _bookImageBytes;

  String? _selectedCategory;
  String? _selectedCondition;
  bool _isUploading = false;

  // ID kategori berdasarkan hasil pemeriksaan database Supabase.
  static const Map<String, int> _categoryIds = {
    'Kuliah': 11,
    'Novel': 12,
    'Anak-anak': 13,
    'Komik': 14,
    'Umum': 15,
    'Pelajaran': 16,
    'Biografi': 17,
    'Sejarah': 18,
  };

  // Label tampilan dipetakan ke nilai enum database.
  static const Map<String, String> _conditionValues = {
    'Sangat Baik (Seperti Baru)': 'Baru',
    'Baik (Ada sedikit catatan)': 'Bekas_Layak',
    'Cukup Baik (Ada highlight)': 'Bekas_Cukup',
  };

  List<String> get _categories => _categoryIds.keys.toList();

  List<String> get _conditions => _conditionValues.keys.toList();

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // =========================================================
  // PILIH FOTO
  // =========================================================

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image == null) return;

      final Uint8List bytes = await image.readAsBytes();

      if (!mounted) return;

      setState(() {
        _bookImage = image;
        _bookImageBytes = bytes;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memilih gambar: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Wrap(
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Pilih Sumber Foto',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Color(0xFF2E7D32)),
                title: const Text('Ambil dari Kamera'),
                onTap: () {
                  Navigator.pop(sheetContext);
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
                  Navigator.pop(sheetContext);
                  _pickImage(ImageSource.gallery);
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  // =========================================================
  // UPLOAD FOTO KE SUPABASE STORAGE
  // =========================================================

  Future<({String path, String publicUrl})> _uploadImageToSupabase(
    XFile imageFile,
  ) async {
    final authUser = _supabase.auth.currentUser;

    if (authUser == null) {
      throw Exception('Pengguna belum login.');
    }

    final int dotIndex = imageFile.name.lastIndexOf('.');

    final String extension = dotIndex >= 0
        ? imageFile.name.substring(dotIndex + 1).toLowerCase()
        : 'jpg';

    const Set<String> allowedExtensions = {'jpg', 'jpeg', 'png', 'webp'};

    if (!allowedExtensions.contains(extension)) {
      throw Exception(
        'Format foto tidak didukung. '
        'Gunakan JPG, JPEG, PNG, atau WEBP.',
      );
    }

    final String contentType = switch (extension) {
      'png' => 'image/png',
      'webp' => 'image/webp',
      _ => 'image/jpeg',
    };

    final String fileName =
        'book_${DateTime.now().millisecondsSinceEpoch}.$extension';

    final String filePath = 'books/${authUser.id}/$fileName';

    final Uint8List bytes = await imageFile.readAsBytes();

    await _supabase.storage
        .from('book-images')
        .uploadBinary(
          filePath,
          bytes,
          fileOptions: FileOptions(contentType: contentType, upsert: false),
        );

    final String publicUrl = _supabase.storage
        .from('book-images')
        .getPublicUrl(filePath);

    return (path: filePath, publicUrl: publicUrl);
  }

  // Membersihkan foto apabila penyimpanan database gagal.
  Future<void> _deleteUploadedImage(String filePath) async {
    try {
      await _supabase.storage.from('book-images').remove([filePath]);
    } catch (e) {
      debugPrint('Gagal membersihkan foto: $e');
    }
  }

  // =========================================================
  // SIMPAN BUKU MELALUI CONTROLLER DAN SERVICE
  // =========================================================

  Future<void> _submitBook() async {
    if (_isUploading) return;

    if (!_formKey.currentState!.validate()) return;

    if (_bookImage == null || _bookImageBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Foto buku wajib dipilih.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Validasi harga sebelum upload foto.
    final String rawPrice = _priceController.text.replaceAll(
      RegExp(r'[.,\s]'),
      '',
    );

    final int? price = int.tryParse(rawPrice);

    if (price == null || price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masukkan harga berupa angka yang lebih besar dari 0.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final int? categoryId = _categoryIds[_selectedCategory];

    final String? condition = _conditionValues[_selectedCondition];

    if (categoryId == null || condition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kategori atau kondisi buku tidak valid.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_supabase.auth.currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sesi login tidak ditemukan. Silakan login kembali.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isUploading = true);

    String? uploadedImagePath;

    try {
      // 1. Upload foto ke Supabase Storage.
      final uploadedImage = await _uploadImageToSupabase(_bookImage!);

      uploadedImagePath = uploadedImage.path;

      // 2. Bentuk model berdasarkan kolom tabel public.buku.
      final BookModel book = BookModel(
        judulBuku: _titleController.text.trim(),
        penulis: _authorController.text.trim(),
        kategoriId: categoryId,
        kondisiBuku: condition,
        deskripsi: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        harga: price,
        jenisTransaksi: 'Jual',
        fotoBuku: uploadedImage.publicUrl,
        statusBuku: 'Tersedia',
      );

      // 3. Simpan melalui BookController.
      // Controller akan memanggil BookService.
      final BookController controller = context.read<BookController>();

      final bool success = await controller.addBook(book);

      if (!success) {
        throw Exception(
          controller.errorMessage ?? 'Database menolak penyimpanan buku.',
        );
      }

      // Database berhasil menyimpan buku.
      // Jangan hapus foto yang sudah digunakan.
      uploadedImagePath = null;

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Buku berhasil diunggah.'),
          backgroundColor: Color(0xFF2E7D32),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      // Jika database gagal, hapus foto yang terlanjur diunggah.
      if (uploadedImagePath != null) {
        await _deleteUploadedImage(uploadedImagePath);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan buku: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  // =========================================================
  // TAMPILAN FORMULIR
  // =========================================================

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
          onPressed: _isUploading ? null : () => Navigator.pop(context),
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
                    // Area upload foto.
                    Center(
                      child: GestureDetector(
                        onTap: _showImageSourceDialog,
                        child: Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: _bookImageBytes != null
                                  ? primaryGreen
                                  : Colors.grey[300]!,
                              width: 2,
                            ),
                          ),
                          child: _bookImageBytes != null
                              ? Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(14),
                                      child: Image.memory(
                                        _bookImageBytes!,
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
                                        ),
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

                    _buildDropdown(
                      'Kategori',
                      _selectedCategory,
                      _categories,
                      'Pilih kategori buku',
                      (value) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      },
                    ),

                    const SizedBox(height: 16),

                    _buildDropdown(
                      'Kondisi Buku',
                      _selectedCondition,
                      _conditions,
                      'Pilih kondisi buku',
                      (value) {
                        setState(() {
                          _selectedCondition = value;
                        });
                      },
                    ),

                    const SizedBox(height: 16),

                    _buildTextField(
                      'Harga Jual',
                      _priceController,
                      'Masukkan harga (contoh: 75000)',
                      isNumber: true,
                      prefix: 'Rp ',
                    ),

                    const SizedBox(height: 16),

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

  // =========================================================
  // TEXT FIELD
  // =========================================================

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
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return '$label wajib diisi';
            }

            return null;
          },
        ),
      ],
    );
  }

  // =========================================================
  // DROPDOWN
  // =========================================================

  Widget _buildDropdown(
    String label,
    String? value,
    List<String> items,
    String hint,
    ValueChanged<String?> onChanged,
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
              .map(
                (item) =>
                    DropdownMenuItem<String>(value: item, child: Text(item)),
              )
              .toList(),
          onChanged: onChanged,
          validator: (selectedValue) {
            if (selectedValue == null) {
              return '$label wajib dipilih';
            }

            return null;
          },
        ),
      ],
    );
  }
}
