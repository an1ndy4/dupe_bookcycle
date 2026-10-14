
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/book_controller.dart';
import '../widgets/book_card.dart';

class CategoryScreen extends StatefulWidget {
  final int kategoriId;
  final String namaKategori;

  const CategoryScreen({
    super.key,
    required this.kategoriId,
    required this.namaKategori,
  });

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context
          .read<BookController>()
          .fetchBooksByCategory(widget.kategoriId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF092B8F),
        elevation: 0,
        title: Text(
          widget.namaKategori,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Consumer<BookController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF087F3E),
              ),
            );
          }

          if (controller.errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 50,
                      color: Colors.redAccent,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Buku gagal dimuat.',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      controller.errorMessage!,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        controller.fetchBooksByCategory(
                          widget.kategoriId,
                        );
                      },
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            );
          }

          // Pastikan buku hanya berasal dari kategori yang dipilih.
          final books = controller.books
              .where(
                (book) => book.kategoriId == widget.kategoriId,
              )
              .toList();

          if (books.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.menu_book_outlined,
                      size: 72,
                      color: Color(0xFF087F3E),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Belum Ada Buku ${widget.namaKategori}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF092B8F),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Buku dalam kategori ini akan muncul '
                      'di sini setelah tersedia.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: books.length,
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 16,
              childAspectRatio: 0.62,
            ),
            itemBuilder: (context, index) {
              return BookCard(
                book: books[index],
              );
            },
          );
        },
      ),
    );
  }
}
