import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SellBookScreen extends StatefulWidget {
  const SellBookScreen({super.key});

  @override
  State<SellBookScreen> createState() => _SellBookScreenState();
}

class _SellBookScreenState extends State<SellBookScreen> {
  // ==========================================================
  // CONTROLLER INPUT
  // ==========================================================

  final TextEditingController _judulController = TextEditingController();

  final TextEditingController _penulisController = TextEditingController();

  final TextEditingController _hargaController = TextEditingController();

  final TextEditingController _deskripsiController = TextEditingController();

  // ==========================================================
  // DATA FOTO
  // ==========================================================

  XFile? _fotoBuku;
  Uint8List? _fotoBytes;

  // ==========================================================
  // DATA PILIHAN
  // ==========================================================

  String? _selectedKategori;
  String? _selectedKondisi;

  // ==========================================================
  // WARNA
  // ==========================================================

  static const Color green = Color(0xFF087F3E);
  static const Color blue = Color(0xFF092B8F);
  static const Color lightBorder = Color(0xFFDCE8E4);
  static const Color greyText = Color(0xFF78909C);

  // ==========================================================
  // DISPOSE
  // ==========================================================

  @override
  void dispose() {
    _judulController.dispose();
    _penulisController.dispose();
    _hargaController.dispose();
    _deskripsiController.dispose();

    super.dispose();
  }

  // ==========================================================
  // PILIH FOTO DARI GALERI
  // ==========================================================

  Future<void> _pilihFoto() async {
    final ImagePicker picker = ImagePicker();

    final XFile? foto = await picker.pickImage(source: ImageSource.gallery);

    // Jika pengguna membatalkan pilih foto
    if (foto == null) {
      return;
    }

    // Membaca foto menjadi bytes
    final Uint8List bytes = await foto.readAsBytes();

    setState(() {
      _fotoBuku = foto;
      _fotoBytes = bytes;
    });
  }

  // ==========================================================
  // UNGGAH BUKU
  // ==========================================================

  void _unggahBuku() {
    if (_fotoBuku == null) {
      _pesan('Foto buku belum dipilih.');
      return;
    }

    if (_judulController.text.trim().isEmpty) {
      _pesan('Judul buku belum diisi.');
      return;
    }

    if (_penulisController.text.trim().isEmpty) {
      _pesan('Penulis belum diisi.');
      return;
    }

    if (_selectedKategori == null) {
      _pesan('Kategori belum dipilih.');
      return;
    }

    if (_selectedKondisi == null) {
      _pesan('Kondisi buku belum dipilih.');
      return;
    }

    if (_hargaController.text.trim().isEmpty) {
      _pesan('Harga jual belum diisi.');
      return;
    }

    _pesan('Data buku siap diunggah.');
  }

  // ==========================================================
  // PESAN
  // ==========================================================

  void _pesan(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ======================================================
      // APP BAR
      // ======================================================
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,

        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: blue,
            size: 19,
          ),
        ),

        title: const Text(
          'Jual Buku',
          style: TextStyle(
            color: blue,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      // ======================================================
      // BODY
      // ======================================================
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 3, 16, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // =================================================
              // FOTO BUKU
              // =================================================

              GestureDetector(
                onTap: _pilihFoto,
                child: Container(
                  width: double.infinity,
                  height: 82,

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(7),
                    border: Border.all(color: const Color(0xFFB9DCD0)),
                  ),

                  child: _fotoBytes == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.camera_alt_rounded,
                              color: green,
                              size: 28,
                            ),

                            SizedBox(height: 3),

                            Text(
                              'Tambah Foto Buku',
                              style: TextStyle(
                                color: green,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),

                            SizedBox(height: 1),

                            Text(
                              'Unggah foto sampai buku',
                              style: TextStyle(color: green, fontSize: 8),
                            ),
                          ],
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(7),

                          child: Image.memory(
                            _fotoBytes!,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 11),

              // =================================================
              // JUDUL
              // =================================================
              _label('Judul Buku'),

              const SizedBox(height: 4),

              _textField(
                controller: _judulController,
                hint: 'Masukkan judul buku',
              ),

              const SizedBox(height: 8),

              // =================================================
              // PENULIS
              // =================================================
              _label('Penulis'),

              const SizedBox(height: 4),

              _textField(
                controller: _penulisController,
                hint: 'Masukkan nama penulis',
              ),

              const SizedBox(height: 8),

              // =================================================
              // KATEGORI
              // =================================================
              _label('Kategori'),

              const SizedBox(height: 4),

              _dropdown(
                value: _selectedKategori,
                hint: 'Pilih kategori',

                items: const [
                  'Fiksi',
                  'Non Fiksi',
                  'Pelajaran',
                  'Komik',
                  'Self Help',
                  'Teknologi',
                  'Bisnis',
                  'Lainnya',
                ],

                onChanged: (value) {
                  setState(() {
                    _selectedKategori = value;
                  });
                },
              ),

              const SizedBox(height: 8),

              // =================================================
              // KONDISI BUKU
              // =================================================
              _label('Kondisi Buku'),

              const SizedBox(height: 4),

              _dropdown(
                value: _selectedKondisi,
                hint: 'Pilih kondisi',

                items: const ['Baru', 'Bekas Layak', 'Bekas Cukup'],

                onChanged: (value) {
                  setState(() {
                    _selectedKondisi = value;
                  });
                },
              ),

              const SizedBox(height: 8),

              // =================================================
              // HARGA
              // =================================================
              _label('Harga Jual'),

              const SizedBox(height: 4),

              _textField(
                controller: _hargaController,
                hint: 'Masukkan harga jual',
                keyboardType: TextInputType.number,
                prefixText: 'Rp ',
              ),

              const SizedBox(height: 8),

              // =================================================
              // DESKRIPSI
              // =================================================
              _label('Deskripsi'),

              const SizedBox(height: 4),

              SizedBox(
                height: 68,

                child: TextField(
                  controller: _deskripsiController,

                  maxLines: 3,

                  style: const TextStyle(color: blue, fontSize: 9.5),

                  decoration: InputDecoration(
                    hintText: 'Ceritakan kondisi buku, jumlah halaman, dll',

                    hintStyle: const TextStyle(color: greyText, fontSize: 9),

                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7),

                      borderSide: const BorderSide(color: lightBorder),
                    ),

                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7),

                      borderSide: const BorderSide(color: lightBorder),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7),

                      borderSide: const BorderSide(color: green),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 13),

              // =================================================
              // TOMBOL UNGGAH
              // =================================================
              SizedBox(
                width: double.infinity,
                height: 39,

                child: ElevatedButton(
                  onPressed: _unggahBuku,

                  style: ElevatedButton.styleFrom(
                    backgroundColor: green,
                    foregroundColor: Colors.white,
                    elevation: 0,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),

                  child: const Text(
                    'Unggah',

                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // LABEL
  // ==========================================================

  Widget _label(String text) {
    return Text(
      text,

      style: const TextStyle(
        color: blue,
        fontSize: 10,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  // ==========================================================
  // TEXT FIELD
  // ==========================================================

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    String? prefixText,
  }) {
    return SizedBox(
      height: 33,

      child: TextField(
        controller: controller,
        keyboardType: keyboardType,

        style: const TextStyle(color: blue, fontSize: 9.5),

        decoration: InputDecoration(
          hintText: hint,

          hintStyle: const TextStyle(color: greyText, fontSize: 9),

          prefixText: prefixText,

          prefixStyle: const TextStyle(color: blue, fontSize: 9.5),

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 0,
          ),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),

            borderSide: const BorderSide(color: lightBorder),
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),

            borderSide: const BorderSide(color: lightBorder),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),

            borderSide: const BorderSide(color: green),
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // DROPDOWN
  // ==========================================================

  Widget _dropdown({
    required String? value,
    required String hint,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      height: 33,

      padding: const EdgeInsets.symmetric(horizontal: 10),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),

        border: Border.all(color: lightBorder),
      ),

      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,

          isExpanded: true,

          hint: Text(
            hint,

            style: const TextStyle(color: greyText, fontSize: 9),
          ),

          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: blue,
            size: 17,
          ),

          style: const TextStyle(color: blue, fontSize: 9.5),

          items: items.map((item) {
            return DropdownMenuItem<String>(value: item, child: Text(item));
          }).toList(),

          onChanged: onChanged,
        ),
      ),
    );
  }
}
