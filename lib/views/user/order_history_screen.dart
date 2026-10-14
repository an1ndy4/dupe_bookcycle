
import 'package:flutter/material.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  static const green = Color(0xFF087F3E);
  static const blue = Color(0xFF092B8F);
  static const lightBlue = Color(0xFFEEF5FF);

  int selectedTab = 0;

  final List<Map<String, dynamic>> orders = [
    {
      'title': 'Atomic Habits',
      'author': 'James Clear',
      'price': 'Rp75.000',
      'status': 'Dalam Pengiriman',
      'type': 'Dibeli',
      'date': '27 Mei 2024',
      'icon': Icons.menu_book,
    },
    {
      'title': 'The One Thing',
      'author': 'Gary Keller',
      'price': 'Rp65.000',
      'status': 'Selesai',
      'type': 'Dibeli',
      'date': '20 Mei 2024',
      'icon': Icons.book,
    },
    {
      'title': 'Laut Bercerita',
      'author': 'Leila S. Chudori',
      'price': 'Rp80.000',
      'status': 'Selesai',
      'type': 'Dijual',
      'date': '18 Mei 2024',
      'icon': Icons.auto_stories,
    },
    {
      'title': 'Bumi Manusia',
      'author': 'Pramoedya Ananta Toer',
      'price': 'Rp60.000',
      'status': 'Menunggu Konfirmasi',
      'type': 'Ditukar',
      'date': '15 Mei 2024',
      'icon': Icons.menu_book,
    },
  ];

  final tabs = ['Semua', 'Dibeli', 'Dijual', 'Ditukar'];

  @override
  Widget build(BuildContext context) {
    final filteredOrders = selectedTab == 0
        ? orders
        : orders.where((order) => order['type'] == tabs[selectedTab]).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: blue),
        ),
        title: const Text(
          'Riwayat Pesanan',
          style: TextStyle(
            color: blue,
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: List.generate(
                tabs.length,
                (index) => _tabItem(tabs[index], index),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: filteredOrders.isEmpty
                ? const Center(
                    child: Text(
                      'Belum ada pesanan.',
                      style: TextStyle(color: blue),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(15, 4, 15, 20),
                    itemCount: filteredOrders.length,
                    itemBuilder: (context, index) =>
                        _orderCard(filteredOrders[index]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _tabItem(String title, int index) {
    final selected = selectedTab == index;

    return GestureDetector(
      onTap: () => setState(() => selectedTab = index),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? green : const Color(0xFFEFF8F3),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: selected ? Colors.white : green,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _orderCard(Map<String, dynamic> order) {
    final status = order['status'] as String;
    final statusColor = status == 'Selesai'
        ? green
        : status == 'Dalam Pengiriman'
            ? Colors.orange
            : const Color(0xFF079CEB);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 66,
                height: 84,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF8F3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  order['icon'] as IconData,
                  color: green,
                  size: 38,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order['title'] as String,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: blue,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      order['author'] as String,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      order['price'] as String,
                      style: const TextStyle(
                        color: green,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      order['date'] as String,
                      style: const TextStyle(
                        color: Color(0xFF8A9AB5),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        status,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: () => _showDetail(order),
                style: OutlinedButton.styleFrom(
                  foregroundColor: green,
                  side: const BorderSide(color: green),
                  minimumSize: const Size(70, 32),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Detail',
                  style: TextStyle(fontSize: 11),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDetail(Map<String, dynamic> order) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(22, 20, 22, 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Detail Pesanan',
              style: TextStyle(
                color: blue,
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _detailRow('Buku', order['title'] as String),
            _detailRow('Penulis', order['author'] as String),
            _detailRow('Harga', order['price'] as String),
            _detailRow('Jenis', order['type'] as String),
            _detailRow('Tanggal', order['date'] as String),
            _detailRow('Status', order['status'] as String),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 75,
            child: Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
          const Text(': '),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: blue,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
