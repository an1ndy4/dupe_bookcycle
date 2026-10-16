import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  static const Color green = Color(0xFF087F3E);
  static const Color blue = Color(0xFF092B8F);
  static const Color greyText = Color(0xFF78909C);
  static const Color lightBorder = Color(0xFFDCE8E4);

  // ==========================================================
  // DATA SEMENTARA
  // NANTI AKAN DIGANTI DENGAN DATA DARI DATABASE
  // ==========================================================

  final List<Map<String, dynamic>> _cartItems = [
    {
      'judul': 'Atomic Habits',
      'penulis': 'James Clear',
      'harga': 75000,
      'jumlah': 1,
      'foto': null,
    },
    {
      'judul': 'Dilan 1990',
      'penulis': 'Pidi Baiq',
      'harga': 45000,
      'jumlah': 1,
      'foto': null,
    },
  ];

  final int _ongkir = 15000;

  // ==========================================================
  // FORMAT HARGA
  // ==========================================================

  String _formatHarga(int harga) {
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

  // ==========================================================
  // HITUNG SUBTOTAL
  // ==========================================================

  int get _subtotal {
    int total = 0;

    for (final item in _cartItems) {
      total += (item['harga'] as int) * (item['jumlah'] as int);
    }

    return total;
  }

  // ==========================================================
  // TOTAL
  // ==========================================================

  int get _total {
    if (_cartItems.isEmpty) {
      return 0;
    }

    return _subtotal + _ongkir;
  }

  // ==========================================================
  // TAMBAH JUMLAH
  // ==========================================================

  void _tambahJumlah(int index) {
    setState(() {
      _cartItems[index]['jumlah']++;
    });
  }

  // ==========================================================
  // KURANGI JUMLAH
  // ==========================================================

  void _kurangiJumlah(int index) {
    setState(() {
      if (_cartItems[index]['jumlah'] > 1) {
        _cartItems[index]['jumlah']--;
      }
    });
  }

  // ==========================================================
  // HAPUS ITEM
  // ==========================================================

  void _hapusItem(int index) {
    setState(() {
      _cartItems.removeAt(index);
    });
  }

  // ==========================================================
  // HAPUS SEMUA
  // ==========================================================

  void _hapusSemua() {
    if (_cartItems.isEmpty) {
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Hapus Keranjang?',
            style: TextStyle(color: blue, fontWeight: FontWeight.w700),
          ),
          content: const Text('Semua buku dalam keranjang akan dihapus.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Batal', style: TextStyle(color: greyText)),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _cartItems.clear();
                });

                Navigator.pop(context);
              },
              child: const Text('Hapus', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  // ==========================================================
  // CHECKOUT
  // ==========================================================

  void _checkout() {
    if (_cartItems.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Keranjang masih kosong.')));

      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Halaman Checkout akan dihubungkan selanjutnya.'),
      ),
    );
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
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: blue,
            size: 18,
          ),
        ),

        title: const Text(
          'Keranjang',
          style: TextStyle(
            color: blue,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),

        actions: [
          IconButton(
            onPressed: _hapusSemua,
            icon: const Icon(
              Icons.delete_outline_rounded,
              color: blue,
              size: 20,
            ),
          ),

          const SizedBox(width: 4),
        ],
      ),

      // ======================================================
      // BODY
      // ======================================================
      body: SafeArea(
        child: _cartItems.isEmpty
            ? _emptyCart()
            : Column(
                children: [
                  // DAFTAR BUKU
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 2, 16, 10),
                      itemCount: _cartItems.length,
                      itemBuilder: (context, index) {
                        return _cartItem(index);
                      },
                    ),
                  ),

                  // RINGKASAN
                  _summary(),
                ],
              ),
      ),
    );
  }

  // ==========================================================
  // ITEM KERANJANG
  // ==========================================================

  Widget _cartItem(int index) {
    final item = _cartItems[index];

    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.only(bottom: 9),

      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: lightBorder, width: 1)),
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ==================================================
          // FOTO BUKU
          // ==================================================

          Container(
            width: 58,
            height: 78,

            decoration: BoxDecoration(
              color: const Color(0xFFF3F7F5),
              borderRadius: BorderRadius.circular(5),
            ),

            child: item['foto'] != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.network(item['foto'], fit: BoxFit.cover),
                  )
                : const Icon(Icons.menu_book_rounded, color: green, size: 30),
          ),

          const SizedBox(width: 9),

          // ==================================================
          // INFORMASI BUKU
          // ==================================================
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['judul'],
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
                  item['penulis'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,

                  style: const TextStyle(color: greyText, fontSize: 8.5),
                ),

                const SizedBox(height: 4),

                Text(
                  _formatHarga(item['harga']),

                  style: const TextStyle(
                    color: green,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 7),

                // JUMLAH
                Row(
                  children: [
                    _quantityButton(
                      icon: Icons.remove,
                      onPressed: () {
                        _kurangiJumlah(index);
                      },
                    ),

                    Container(
                      width: 25,
                      height: 24,
                      alignment: Alignment.center,
                      child: Text(
                        '${item['jumlah']}',
                        style: const TextStyle(
                          color: blue,
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    _quantityButton(
                      icon: Icons.add,
                      onPressed: () {
                        _tambahJumlah(index);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ==================================================
          // HAPUS ITEM
          // ==================================================
          IconButton(
            onPressed: () {
              _hapusItem(index);
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 25, minHeight: 25),
            icon: const Icon(
              Icons.delete_outline_rounded,
              color: blue,
              size: 17,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // BUTTON JUMLAH
  // ==========================================================

  Widget _quantityButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 24,
      height: 24,

      child: OutlinedButton(
        onPressed: onPressed,

        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          side: const BorderSide(color: lightBorder),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),

        child: Icon(icon, size: 13, color: blue),
      ),
    );
  }

  // ==========================================================
  // RINGKASAN BELANJA
  // ==========================================================

  Widget _summary() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),

      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: lightBorder)),
      ),

      child: Column(
        children: [
          _summaryRow('Subtotal', _formatHarga(_subtotal)),

          const SizedBox(height: 5),

          _summaryRow('Ongkir', _formatHarga(_ongkir)),

          const SizedBox(height: 6),

          _summaryRow('Total', _formatHarga(_total), isTotal: true),

          const SizedBox(height: 10),

          // CHECKOUT
          SizedBox(
            width: double.infinity,
            height: 39,

            child: ElevatedButton(
              onPressed: _checkout,

              style: ElevatedButton.styleFrom(
                backgroundColor: green,
                foregroundColor: Colors.white,
                elevation: 0,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
              ),

              child: const Text(
                'Checkout',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // BARIS RINGKASAN
  // ==========================================================

  Widget _summaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,

      children: [
        Text(
          label,

          style: TextStyle(
            color: blue,
            fontSize: isTotal ? 12 : 9,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
          ),
        ),

        Text(
          value,

          style: TextStyle(
            color: isTotal ? green : blue,
            fontSize: isTotal ? 12 : 9,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // KERANJANG KOSONG
  // ==========================================================

  Widget _emptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: const [
          Icon(Icons.shopping_cart_outlined, color: green, size: 55),

          SizedBox(height: 12),

          Text(
            'Keranjang masih kosong',
            style: TextStyle(
              color: blue,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),

          SizedBox(height: 5),

          Text(
            'Yuk cari buku yang kamu suka!',
            style: TextStyle(color: greyText, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
