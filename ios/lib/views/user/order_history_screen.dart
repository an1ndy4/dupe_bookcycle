import 'package:flutter/material.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() =>
      _OrderHistoryScreenState();
}

class _OrderHistoryScreenState
    extends State<OrderHistoryScreen> {

  static const Color green = Color(0xFF087F3E);
  static const Color blue = Color(0xFF092B8F);

  int selectedTab = 0;

  final List<Map<String, dynamic>> orders = [
    {
      'title': 'Atomic Habits',
      'author': 'James Clear',
      'price': 'Rp75.000',
      'status': 'Dalam Pengiriman',
      'statusColor': Colors.orange,
      'icon': Icons.menu_book,
    },
    {
      'title': 'The One Thing',
      'author': 'Gary Keller',
      'price': 'Rp65.000',
      'status': 'Selesai',
      'statusColor': green,
      'icon': Icons.book,
    },
    {
      'title': 'Laut Bercerita',
      'author': 'Leila S. Chudori',
      'price': 'Rp80.000',
      'status': 'Selesai',
      'statusColor': green,
      'icon': Icons.auto_stories,
    },
    {
      'title': 'Bumi Manusia',
      'author': 'Pramoedya Ananta Toer',
      'price': 'Rp60.000',
      'status': 'Selesai',
      'statusColor': green,
      'icon': Icons.menu_book,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: blue,
          ),
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

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 5,
            ),
            child: Row(
              children: [
                _tabItem(
                  'Semua',
                  0,
                ),
                _tabItem(
                  'Diproses',
                  1,
                ),
                _tabItem(
                  'Dikirim',
                  2,
                ),
                _tabItem(
                  'Selesai',
                  3,
                ),
                _tabItem(
                  'Ditukar',
                  4,
                ),
              ],
            ),
          ),

          const SizedBox(height: 5),

          Expanded(
            child: ListView.builder(
              padding:
                  const EdgeInsets.fromLTRB(
                15,
                8,
                15,
                20,
              ),
              itemCount: orders.length,
              itemBuilder:
                  (context, index) {

                final order =
                    orders[index];

                return _orderCard(
                  context,
                  order,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabItem(
    String title,
    int index,
  ) {
    final bool selected =
        selectedTab == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = index;
        });
      },
      child: Container(
        margin:
            const EdgeInsets.only(right: 7),
        padding:
            const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 9,
        ),
        decoration: BoxDecoration(
          color: selected
              ? green
              : const Color(0xFFF2F7FF),
          borderRadius:
              BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: selected
                ? Colors.white
                : blue,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _orderCard(
    BuildContext context,
    Map<String, dynamic> order,
  ) {
    return Container(
      margin:
          const EdgeInsets.only(bottom: 12),
      padding:
          const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE4E9F1),
        ),
      ),
      child: Column(
        children: [

          Row(
            children: [

              Container(
                width: 65,
                height: 82,
                decoration: BoxDecoration(
                  color:
                      const Color(0xFFEFF8F3),
                  borderRadius:
                      BorderRadius.circular(8),
                ),
                child: Icon(
                  order['icon'],
                  color: green,
                  size: 38,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    Text(
                      order['title'],
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: blue,
                        fontSize: 14,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      order['author'],
                      style:
                          const TextStyle(
                        color: Colors.grey,
                        fontSize: 11,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      order['price'],
                      style:
                          const TextStyle(
                        color: green,
                        fontSize: 13,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.chevron_right,
                color: Colors.grey,
              ),
            ],
          ),

          const SizedBox(height: 10),

          const Divider(height: 1),

          const SizedBox(height: 10),

          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [

              Row(
                children: [

                  Container(
                    width: 8,
                    height: 8,
                    decoration:
                        BoxDecoration(
                      color:
                          order['statusColor'],
                      shape:
                          BoxShape.circle,
                    ),
                  ),

                  const SizedBox(width: 6),

                  Text(
                    order['status'],
                    style: TextStyle(
                      color:
                          order['statusColor'],
                      fontSize: 11,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ],
              ),

              OutlinedButton(
                onPressed: () {
                  _showDetail(
                    context,
                    order,
                  );
                },
                style:
                    OutlinedButton.styleFrom(
                  foregroundColor: green,
                  side:
                      const BorderSide(
                    color: green,
                  ),
                  minimumSize:
                      const Size(75, 32),
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      7,
                    ),
                  ),
                ),
                child: const Text(
                  'Detail',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDetail(
    BuildContext context,
    Map<String, dynamic> order,
  ) {
    showModalBottomSheet(
      context: context,
      shape:
          const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(
          top: Radius.circular(22),
        ),
      ),
      builder: (context) {
        return Padding(
          padding:
              const EdgeInsets.all(22),
          child: Column(
            mainAxisSize:
                MainAxisSize.min,
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [

              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration:
                      BoxDecoration(
                    color:
                        Colors.grey.shade300,
                    borderRadius:
                        BorderRadius.circular(
                      10,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Detail Pesanan',
                style: TextStyle(
                  color: blue,
                  fontSize: 19,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              _detailRow(
                'Buku',
                order['title'],
              ),

              _detailRow(
                'Penulis',
                order['author'],
              ),

              _detailRow(
                'Harga',
                order['price'],
              ),

              _detailRow(
                'Status',
                order['status'],
              ),

              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _detailRow(
    String title,
    String value,
  ) {
    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 12,
      ),
      child: Row(
        children: [

          SizedBox(
            width: 70,
            child: Text(
              title,
              style:
                  const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ),

          const Text(': '),

          Expanded(
            child: Text(
              value,
              style:
                  const TextStyle(
                color: blue,
                fontSize: 12,
                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}