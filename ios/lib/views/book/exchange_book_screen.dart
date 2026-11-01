import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../controllers/book_controller.dart';
import '../../models/book_model.dart';

class ExchangeBookScreen extends StatefulWidget {
  const ExchangeBookScreen({Key? key}) : super(key: key);

  @override
  State<ExchangeBookScreen> createState() => _ExchangeBookScreenState();
}

class _ExchangeBookScreenState extends State<ExchangeBookScreen> {
  static const Color primaryGreen = Color(0xFF2E7D32);

  final SupabaseClient _supabase = Supabase.instance.client;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImagePicker _imagePicker = ImagePicker();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  XFile? _bookImage;
  Uint8List? _bookImageBytes;

  String? _selectedCategory;
  String? _selectedCondition;
  bool _isUploading = false;

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
    _descriptionController.dispose();
    super.dispose();
  }

  // Memilih foto dari kamera atau galeri.
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
                leading: const Icon(Icons.camera_alt, color: primaryGreen),
                title: const Text('Ambil dari Kamera'),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: primaryGreen),
                title: const Text('Pilih dari Galeri'),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Mengunggah foto ke Supabase Storage.
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
        'Format foto tidak didukung. Gunakan JPG, PNG, atau WEBP.',
      );
    }

    final String contentType = switch (extension) {
      'png' => 'image/png',
      'webp' => 'image/webp',
      _ => 'image/jpeg',
    };

    final String fileName =
        'book_exchange_${DateTime.now().millisecondsSinceEpoch}.$extension';

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

  Future<void> _deleteUploadedImage(String filePath) async {
    try {
      await _supabase.storage.from('book-images').remove([filePath]);
    } catch (e) {
      debugPrint('Gagal membersihkan foto: $e');
    }
  }

  // Menyimpan buku dengan jenis transaksi Tukar.
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

    final int? categoryId = _categoryIds[_selectedCategory];
    final String? condition = _conditionValues[_selectedCondition];

    if (categoryId == null || condition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kategori atau kondisi buku belum valid.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_supabase.auth.currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan login terlebih dahulu.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isUploading = true);

    String? uploadedImagePath;

    try {
      // 1. Upload foto.
      final uploadedImage = await _uploadImageToSupabase(_bookImage!);

      uploadedImagePath = uploadedImage.path;

      // 2. Bentuk model sebagai buku tukar.
      final BookModel book = BookModel(
        judulBuku: _titleController.text.trim(),
        penulis: _authorController.text.trim(),
        kategoriId: categoryId,
        kondisiBuku: condition,
        deskripsi: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        harga: null,
        jenisTransaksi: 'Tukar',
        fotoBuku: uploadedImage.publicUrl,
        statusBuku: 'Tersedia',
      );

      // 3. Simpan melalui Controller dan Service.
      final controller = context.read<BookController>();
      final bool success = await controller.addBook(book);

      if (!success) {
        throw Exception(
          controller.errorMessage ?? 'Database menolak penyimpanan buku.',
        );
      }

      // Foto sudah digunakan oleh data buku.
      uploadedImagePath = null;

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Buku berhasil diajukan untuk ditukar.'),
          backgroundColor: primaryGreen,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (uploadedImagePath != null) {
        await _deleteUploadedImage(uploadedImagePath);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengajukan tukar buku: $e'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: _isUploading ? null : () => Navigator.pop(context),
        ),
        title: const Text(
          'Tukar Buku',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
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
                    // Area foto buku.
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
                                        width: double.infinity,
                                        height: double.infinity,
                                        fit: BoxFit.cover,
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
                        setState(() => _selectedCategory = value);
                      },
                    ),

                    const SizedBox(height: 16),

                    _buildDropdown(
                      'Kondisi Buku',
                      _selectedCondition,
                      _conditions,
                      'Pilih kondisi buku',
                      (value) {
                        setState(() => _selectedCondition = value);
                      },
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
                        child: const Text('Ajukan Tukar'),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    String hint,
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
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: primaryGreen, width: 2),
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
              borderSide: const BorderSide(color: primaryGreen, width: 2),
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
