import 'package:flutter/material.dart';

import '../../models/book_model.dart';

class BookDetailScreen extends StatelessWidget {
  final BookModel book;

  const BookDetailScreen({super.key, required this.book});

  static const Color green = Color(0xFF087F3E);
  static const Color blue = Color(0xFF092B8F);
  static const Color lightBorder = Color(0xFFDCE8E4);
  static const Color greyText = Color(0xFF71858D);

  String _formatHarga(int? harga) {
    if (harga == null || harga == 0) {
      return 'Rp0';
    }

    final value = harga.toString();
    final buffer = StringBuffer();

    for (int i = 0; i < value.length; i++) {
      if (i > 0 && (value.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(value[i]);
    }

    return 'Rp${buffer.toString()}';
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

  String _formatJenisTransaksi(String jenis) {
    switch (jenis) {
      case 'Jual':
        return 'Buku Fisik';
      case 'Tukar':
        return 'Tukar Buku';
      case 'Jual_Tukar':
        return 'Jual / Tukar';
      default:
        return jenis;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,

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

        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Buku ditambahkan ke favorit.')),
              );
            },
            icon: const Icon(
              Icons.favorite_border_rounded,
              color: blue,
              size: 21,
            ),
          ),

          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Fitur bagikan akan segera tersedia.'),
                ),
              );
            },
            icon: const Icon(Icons.share_rounded, color: blue, size: 19),
          ),

          const SizedBox(width: 4),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 4, 18, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==================================================
              // INFORMASI UTAMA BUKU
              // ==================================================

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // COVER
                  Container(
                    width: 92,
                    height: 125,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F7F5),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: book.fotoBuku != null && book.fotoBuku!.isNotEmpty
                        ? Image.network(
                            book.fotoBuku!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.menu_book_rounded,
                                size: 48,
                                color: green,
                              );
                            },
                          )
                        : const Icon(
                            Icons.menu_book_rounded,
                            size: 48,
                            color: green,
                          ),
                  ),

                  const SizedBox(width: 13),

                  // INFORMASI
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book.judulBuku,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: blue,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          book.penulis ?? '-',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: greyText, fontSize: 11),
                        ),

                        const SizedBox(height: 8),

                        // RATING SESUAI MOCKUP
                        Row(
                          children: const [
                            Icon(
                              Icons.star_rounded,
                              color: Color(0xFFFFC107),
                              size: 15,
                            ),
                            SizedBox(width: 3),
                            Text(
                              '4.8 (120 ulasan)',
                              style: TextStyle(color: blue, fontSize: 10),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        if (book.jenisTransaksi == 'Jual' ||
                            book.jenisTransaksi == 'Jual_Tukar')
                          Text(
                            _formatHarga(book.harga),
                            style: const TextStyle(
                              color: blue,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                        if (book.jenisTransaksi == 'Tukar')
                          const Text(
                            'Tukar Buku',
                            style: TextStyle(
                              color: blue,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                        const SizedBox(height: 4),

                        Text(
                          book.statusBuku,
                          style: const TextStyle(
                            color: green,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              // ==================================================
              // DESKRIPSI
              // ==================================================
              const Text(
                'Deskripsi',
                style: TextStyle(
                  color: blue,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                book.deskripsi?.isNotEmpty == true
                    ? book.deskripsi!
                    : 'Belum ada deskripsi buku.',
                style: const TextStyle(
                  color: blue,
                  fontSize: 10.5,
                  height: 1.45,
                ),
              ),

              const SizedBox(height: 16),

              const Divider(height: 1, color: lightBorder),

              const SizedBox(height: 13),

              // ==================================================
              // INFORMASI BUKU
              // ==================================================
              _infoRow(
                'Kategori',
                book.kategoriId != null ? 'Kategori #${book.kategoriId}' : '-',
              ),

              _infoRow('Tipe', _formatJenisTransaksi(book.jenisTransaksi)),

              _infoRow('Penulis', book.penulis ?? '-'),

              _infoRow('Penerbit', book.penerbit ?? '-'),

              _infoRow('Kondisi', _formatKondisi(book.kondisiBuku)),

              const SizedBox(height: 14),

              // ==================================================
              // TOMBOL
              // ==================================================
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 42,
                      child: OutlinedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Chat Penjual akan segera tersedia.',
                              ),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: green,
                          side: const BorderSide(color: green, width: 1.2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Chat Penjual',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 9),

                  Expanded(
                    child: SizedBox(
                      height: 42,
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Buku ditambahkan untuk dibeli.'),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: green,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Beli Sekarang',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 70,
            child: Text(
              label,
              style: const TextStyle(
                color: blue,
                fontSize: 10.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          const Text(':', style: TextStyle(color: blue, fontSize: 10.5)),

          const SizedBox(width: 8),

          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: blue, fontSize: 10.5),
            ),
          ),
        ],
      ),
    );
  }
}
