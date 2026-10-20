import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

import '../widgets/chat_screen.dart';
import '../widgets/cart_screen.dart';

class BookDetailScreen extends StatefulWidget {
  final int bookId;

  const BookDetailScreen({Key? key, required this.bookId}) : super(key: key);

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  final _supabase = Supabase.instance.client;
  Map<String, dynamic>? _book;
  Map<String, dynamic>? _seller;
  bool _isLoading = true;
  bool _isAddingToCart = false;

  @override
  void initState() {
    super.initState();
    _fetchBookData();
  }

  Future<void> _fetchBookData() async {
    try {
      // 1. Ambil buku dari tabel yang benar.
      final bookResponse = await _supabase
          .from('buku')
          .select()
          .eq('buku_id', widget.bookId)
          .maybeSingle();

      if (bookResponse == null) {
        if (!mounted) return;

        setState(() {
          _book = null;
          _seller = null;
          _isLoading = false;
        });

        return;
      }

      // 2. Ambil ID pengguna dan kategori dari data buku.
      final int? userId = (bookResponse['user_id'] as num?)?.toInt();

      final int? kategoriId = (bookResponse['kategori_id'] as num?)?.toInt();

      // 3. Ambil informasi penjual dari tabel users.
      Map<String, dynamic>? sellerResponse;

      if (userId != null) {
        sellerResponse = await _supabase
            .from('users')
            .select('nama_lengkap, nomor_hp')
            .eq('user_id', userId)
            .maybeSingle();
      }

      // 4. Ambil nama kategori dari tabel kategori.
      Map<String, dynamic>? categoryResponse;

      if (kategoriId != null) {
        categoryResponse = await _supabase
            .from('kategori')
            .select('nama_kategori')
            .eq('kategori_id', kategoriId)
            .maybeSingle();
      }

      // 5. Sesuaikan nama kolom database dengan nama
      // yang digunakan oleh tampilan detail buku saat ini.
      final String jenisTransaksi =
          bookResponse['jenis_transaksi']?.toString() ?? 'Jual';

      final Map<String, dynamic> mappedBook = {
        'id': bookResponse['buku_id'],
        'user_id': bookResponse['user_id'],
        'title': bookResponse['judul_buku'] ?? 'Tanpa judul',
        'author': bookResponse['penulis'] ?? '-',
        'price': bookResponse['harga'] ?? 0,
        'description': bookResponse['deskripsi'],
        'image_url': bookResponse['foto_buku'],
        'category': categoryResponse?['nama_kategori'] ?? '-',
        'condition': bookResponse['kondisi_buku'] ?? '-',
        'is_for_sale':
            jenisTransaksi == 'Jual' || jenisTransaksi == 'Jual_Tukar',
        'is_for_exchange':
            jenisTransaksi == 'Tukar' || jenisTransaksi == 'Jual_Tukar',

        // Tabel buku yang kita periksa belum memiliki
        // kolom tanggal pembuatan.
        'created_at': null,
      };

      final Map<String, dynamic>? mappedSeller = sellerResponse == null
          ? null
          : {
              'full_name': sellerResponse['nama_lengkap'] ?? 'Penjual',
              'phone_number': sellerResponse['nomor_hp'] ?? '-',
            };

      if (!mounted) return;

      setState(() {
        _book = mappedBook;
        _seller = mappedSeller;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _book = null;
        _seller = null;
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memuat detail buku: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // 🛒 Tambah ke keranjang

  Future<void> _addToCart() async {
    if (_isAddingToCart) return;

    final authUser = _supabase.auth.currentUser;

    if (authUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan login terlebih dahulu.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isAddingToCart = true);

    try {
      // 1. Cari ID internal pengguna dari tabel users.
      final profile = await _supabase
          .from('users')
          .select('user_id')
          .eq('auth_id', authUser.id)
          .maybeSingle();

      if (profile == null) {
        throw Exception('Profil pengguna tidak ditemukan di database.');
      }

      final int userId = (profile['user_id'] as num).toInt();

      // 2. Periksa apakah buku sudah ada di keranjang.
      final existingCart = await _supabase
          .from('keranjang')
          .select('keranjang_id')
          .eq('user_id', userId)
          .eq('buku_id', widget.bookId)
          .maybeSingle();

      if (existingCart != null) {
        throw Exception('Buku sudah ada di keranjang.');
      }

      // 3. Simpan buku ke tabel keranjang.
      await _supabase.from('keranjang').insert({
        'user_id': userId,
        'buku_id': widget.bookId,
        'jumlah': 1,
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Berhasil menambahkan buku ke keranjang.'),
          backgroundColor: Color(0xFF2E7D32),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isAddingToCart = false);
      }
    }
  }

  // 💬 Chat penjual
  void _chatSeller() {
    // Navigate ke chat screen (akan kita buat nanti)
    Navigator.pushNamed(
      context,
      '/chat',
      arguments: {
        'sellerId': _book!['user_id'],
        'bookId': widget.bookId,
        'sellerName': _seller?['full_name'] ?? 'Penjual',
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryGreen = Color(0xFF2E7D32);

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_book == null) {
      return Scaffold(body: Center(child: Text('Buku tidak ditemukan')));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.black87),
            onPressed: () {
              // Share functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Gambar Buku + Info
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gambar Buku
                Container(
                  width: 120,
                  height: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: _book!['image_url'] != null
                        ? Image.network(
                            _book!['image_url'],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[200],
                                child: const Icon(Icons.book, size: 50),
                              );
                            },
                          )
                        : Container(
                            color: Colors.grey[200],
                            child: const Icon(Icons.book, size: 50),
                          ),
                  ),
                ),
                const SizedBox(width: 16),

                // Info Buku
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _book!['title'],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _book!['author'],
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Rating (bisa ditambahkan nanti)
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 18),
                          const SizedBox(width: 4),
                          const Text(
                            '4.8',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(120 ulasan)',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Harga & Status
                      Row(
                        children: [
                          Text(
                            'Rp${NumberFormat('#,##0').format(_book!['price'])}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: primaryGreen,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: primaryGreen.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _book!['is_for_sale'] == true
                                  ? 'Tersedia'
                                  : 'Ditukar',
                              style: const TextStyle(
                                fontSize: 12,
                                color: primaryGreen,
                                fontWeight: FontWeight.bold,
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

            const SizedBox(height: 24),

            // Deskripsi
            const Text(
              'Deskripsi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _book!['description'] ?? 'Tidak ada deskripsi',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
                height: 1.6,
              ),
            ),

            const SizedBox(height: 24),

            // Info Detail Buku
            _buildInfoRow('Kategori', _book!['category'] ?? '-'),
            const SizedBox(height: 12),
            _buildInfoRow(
              'Tipe',
              _book!['is_for_exchange'] == true ? 'Tukar' : 'Jual',
            ),
            const SizedBox(height: 12),
            _buildInfoRow('Penulis', _book!['author'] ?? '-'),
            const SizedBox(height: 12),
            _buildInfoRow('Kondisi', _book!['condition'] ?? '-'),
            const SizedBox(height: 12),
            _buildInfoRow(
              'Diposting',
              _book!['created_at'] != null
                  ? DateFormat('dd MMM yyyy')
                        .format(DateTime.parse(_book!['created_at']))
                  : '-',
            ),

            const SizedBox(height: 24),

            // Info Penjual
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Informasi Penjual',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: primaryGreen,
                        radius: 20,
                        child: Text(
                          _seller?['full_name']?[0] ?? 'P',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _seller?['full_name'] ?? 'Penjual',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              _seller?['phone_number'] ?? '-',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),

      // Bottom Buttons
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _chatSeller,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: primaryGreen),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Chat Penjual',
                  style: TextStyle(
                    color: primaryGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: _isAddingToCart ? null : _addToCart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isAddingToCart
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(
                        'Beli Sekarang',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ),
        const Text(': ', style: TextStyle(color: Colors.grey)),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ),
      ],
    );
  }
}
