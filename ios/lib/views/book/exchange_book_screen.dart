import 'package:flutter/material.dart';

import '../../models/book_model.dart';

class ExchangeBookScreen extends StatefulWidget {
  const ExchangeBookScreen({super.key});

  @override
  State<ExchangeBookScreen> createState() => _ExchangeBookScreenState();
}

class _ExchangeBookScreenState extends State<ExchangeBookScreen> {
  static const Color green = Color(0xFF087F3E);
  static const Color blue = Color(0xFF092B8F);
  static const Color greyText = Color(0xFF78909C);
  static const Color lightBorder = Color(0xFFDCE8E4);

  final TextEditingController _searchController = TextEditingController();

  int _selectedCategory = 0;

  final List<String> _categories = ['Semua', 'Fiksi', 'Non Fiksi', 'Pelajaran'];

  // Data sementara untuk tampilan.
  // Nanti diganti dengan data dari BookController.
  final List<BookModel> _books = [
    BookModel(
      judulBuku: 'Laut Bercerita',
      penulis: 'Leila S. Chudori',
      kondisiBuku: 'Bekas_Layak',
      jenisTransaksi: 'Tukar',
      statusBuku: 'Tersedia',
    ),
    BookModel(
      judulBuku: 'Dilan 1990',
      penulis: 'Pidi Baiq',
      kondisiBuku: 'Bekas_Layak',
      jenisTransaksi: 'Tukar',
      statusBuku: 'Tersedia',
    ),
    BookModel(
      judulBuku: 'Filosofi Teras',
      penulis: 'Henry Manampiring',
      kondisiBuku: 'Bekas_Layak',
      jenisTransaksi: 'Tukar',
      statusBuku: 'Tersedia',
    ),
    BookModel(
      judulBuku: 'Bumi Manusia',
      penulis: 'Pramoedya Ananta Toer',
      kondisiBuku: 'Bekas_Cukup',
      jenisTransaksi: 'Tukar',
      statusBuku: 'Tersedia',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: blue,
            size: 19,
          ),
        ),

        title: const Text(
          'Pilih Buku untuk Ditukar',
          style: TextStyle(
            color: blue,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            // SEARCH
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 2, 16, 8),
              child: _searchField(),
            ),

            // CATEGORY
            SizedBox(
              height: 32,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final selected = _selectedCategory == index;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory = index;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 13),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: selected ? green : const Color(0xFFF5FAF8),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        _categories[index],
                        style: TextStyle(
                          color: selected ? Colors.white : green,
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 8),

            // DAFTAR BUKU
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 15),
                itemCount: _books.length,
                itemBuilder: (context, index) {
                  return _bookItem(_books[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _searchField() {
    return SizedBox(
      height: 34,
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: blue, fontSize: 9),
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search_rounded, color: blue, size: 17),
          hintText: 'Cari judul, penulis, atau kategori',
          hintStyle: const TextStyle(color: greyText, fontSize: 8.5),
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          filled: true,
          fillColor: const Color(0xFFF8FCFA),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: lightBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: lightBorder),
          ),
        ),
      ),
    );
  }

  Widget _bookItem(BookModel book) {
    return Container(
      height: 84,
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          // COVER
          Container(
            width: 57,
            height: 76,
            decoration: BoxDecoration(
              color: const Color(0xFFF2F6F4),
              borderRadius: BorderRadius.circular(5),
            ),
            child: book.fotoBuku != null && book.fotoBuku!.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.network(book.fotoBuku!, fit: BoxFit.cover),
                  )
                : const Icon(Icons.menu_book_rounded, color: green, size: 30),
          ),

          const SizedBox(width: 10),

          // INFO
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.judulBuku,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: blue,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  book.penulis ?? '-',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: greyText, fontSize: 8.5),
                ),

                const SizedBox(height: 3),

                Text(
                  'Kondisi: ${_formatKondisi(book.kondisiBuku)}',
                  style: const TextStyle(color: greyText, fontSize: 7.5),
                ),
              ],
            ),
          ),

          // PILIH
          SizedBox(
            width: 45,
            height: 25,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ExchangeUploadScreen(selectedBook: book),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: green,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Pilih',
                style: TextStyle(fontSize: 8, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatKondisi(String kondisi) {
    switch (kondisi) {
      case 'Bekas_Layak':
        return 'Bekas Layak';
      case 'Bekas_Cukup':
        return 'Bekas Cukup';
      default:
        return kondisi;
    }
  }
}

// ============================================================
// HALAMAN NO. 11
// UNGGAH BUKU - TUKAR
// ============================================================

class ExchangeUploadScreen extends StatefulWidget {
  final BookModel selectedBook;

  const ExchangeUploadScreen({super.key, required this.selectedBook});

  @override
  State<ExchangeUploadScreen> createState() => _ExchangeUploadScreenState();
}

class _ExchangeUploadScreenState extends State<ExchangeUploadScreen> {
  static const Color green = Color(0xFF087F3E);
  static const Color blue = Color(0xFF092B8F);
  static const Color greyText = Color(0xFF78909C);
  static const Color lightBorder = Color(0xFFDCE8E4);

  final TextEditingController _judulController = TextEditingController();

  final TextEditingController _penulisController = TextEditingController();

  final TextEditingController _deskripsiController = TextEditingController();

  final TextEditingController _jenisBukuController = TextEditingController();

  String? _selectedKategori;
  String? _selectedKondisi;

  @override
  void dispose() {
    _judulController.dispose();
    _penulisController.dispose();
    _deskripsiController.dispose();
    _jenisBukuController.dispose();
    super.dispose();
  }

  void _pilihFoto() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fitur pilih foto akan dihubungkan selanjutnya.'),
      ),
    );
  }

  void _unggah() {
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

    if (_jenisBukuController.text.trim().isEmpty) {
      _pesan('Jenis buku yang dicari belum diisi.');
      return;
    }

    _pesan('Data buku tukar siap diunggah.');
  }

  void _pesan(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: blue,
            size: 19,
          ),
        ),

        title: const Text(
          'Unggah Buku - Tukar',
          style: TextStyle(
            color: blue,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 3, 16, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // FOTO
              GestureDetector(
                onTap: _pilihFoto,
                child: Container(
                  width: double.infinity,
                  height: 82,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    border: Border.all(color: const Color(0xFFB9DCD0)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.camera_alt_rounded, color: green, size: 28),
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
                  ),
                ),
              ),

              const SizedBox(height: 11),

              _label('Judul Buku'),

              const SizedBox(height: 4),

              _textField(
                controller: _judulController,
                hint: 'Masukkan judul buku',
              ),

              const SizedBox(height: 8),

              _label('Penulis'),

              const SizedBox(height: 4),

              _textField(
                controller: _penulisController,
                hint: 'Masukkan nama penulis',
              ),

              const SizedBox(height: 8),

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

              _label('Deskripsi'),

              const SizedBox(height: 4),

              SizedBox(
                height: 63,
                child: TextField(
                  controller: _deskripsiController,
                  maxLines: 3,
                  style: const TextStyle(color: blue, fontSize: 9),
                  decoration: InputDecoration(
                    hintText: 'Ceritakan kondisi buku, jumlah halaman, dll',
                    hintStyle: const TextStyle(color: greyText, fontSize: 8.5),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 7,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7),
                      borderSide: const BorderSide(color: lightBorder),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7),
                      borderSide: const BorderSide(color: lightBorder),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              _label('Jenis Buku yang Dicari'),

              const SizedBox(height: 4),

              _textField(
                controller: _jenisBukuController,
                hint: 'Contoh: buku self improvement, novel, dll',
              ),

              const SizedBox(height: 13),

              SizedBox(
                width: double.infinity,
                height: 39,
                child: ElevatedButton(
                  onPressed: _unggah,
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

  Widget _textField({
    required TextEditingController controller,
    required String hint,
  }) {
    return SizedBox(
      height: 33,
      child: TextField(
        controller: controller,
        style: const TextStyle(color: blue, fontSize: 9.5),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: greyText, fontSize: 9),
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
