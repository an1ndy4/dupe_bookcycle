import 'package:flutter/material.dart';

import '../../models/book_model.dart';
import '../book/book_detail_screen.dart';

class BookCard extends StatelessWidget {
  final BookModel book;

  const BookCard({super.key, required this.book});

  static const Color green = Color(0xFF087F3E);
  static const Color blue = Color(0xFF092B8F);
  static const Color greyText = Color(0xFF78909C);
  static const Color lightBorder = Color(0xFFE1ECE7);

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

  String _getHargaAtauTukar() {
    if (book.jenisTransaksi == 'Jual' || book.jenisTransaksi == 'Jual_Tukar') {
      return _formatHarga(book.harga);
    }

    return 'Tukar';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => BookDetailScreen(book: book)),
        );
      },

      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: lightBorder, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =====================================================
            // FOTO BUKU
            // =====================================================

            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F8F6),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(9),
                  ),
                ),

                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(9),
                  ),

                  child: book.fotoBuku != null && book.fotoBuku!.isNotEmpty
                      ? Image.network(
                          book.fotoBuku!,
                          fit: BoxFit.cover,

                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(
                                Icons.menu_book_rounded,
                                color: green,
                                size: 42,
                              ),
                            );
                          },
                        )
                      : const Center(
                          child: Icon(
                            Icons.menu_book_rounded,
                            color: green,
                            size: 42,
                          ),
                        ),
                ),
              ),
            ),

            // =====================================================
            // INFORMASI BUKU
            // =====================================================
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 7, 8, 8),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // JUDUL
                  Text(
                    book.judulBuku,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,

                    style: const TextStyle(
                      color: blue,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 3),

                  // PENULIS
                  Text(
                    book.penulis ?? '-',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,

                    style: const TextStyle(color: greyText, fontSize: 9),
                  ),

                  const SizedBox(height: 6),

                  // HARGA + KONDISI
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,

                    children: [
                      Expanded(
                        child: Text(
                          _getHargaAtauTukar(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,

                          style: const TextStyle(
                            color: green,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),

                      const SizedBox(width: 4),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 3,
                        ),

                        decoration: BoxDecoration(
                          color: const Color(0xFFE9F6EF),
                          borderRadius: BorderRadius.circular(5),
                        ),

                        child: Text(
                          _formatKondisi(book.kondisiBuku),

                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,

                          style: const TextStyle(
                            color: green,
                            fontSize: 7.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
