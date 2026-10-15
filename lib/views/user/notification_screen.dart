
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() =>
      _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String selectedFilter = 'Semua';

  final List<Map<String, dynamic>> notifications = [
    {
      'title': 'Pesanan Berhasil Dibuat',
      'message':
          'Pesanan buku Laskar Pelangi berhasil dibuat. Silakan lanjutkan pembayaran.',
      'time': 'Baru saja',
      'icon': Icons.shopping_bag_outlined,
      'color': Color(0xFF087F3E),
      'category': 'Pesanan',
      'read': false,
    },
    {
      'title': 'Pembayaran Berhasil',
      'message':
          'Pembayaran pesanan buku berhasil dikonfirmasi. Terima kasih telah berbelanja di BookCycle.',
      'time': '1 jam lalu',
      'icon': Icons.check_circle_outline,
      'color': Color(0xFF1599E8),
      'category': 'Pembayaran',
      'read': false,
    },
    {
      'title': 'Buku Berhasil Dijual',
      'message':
          'Buku yang kamu jual berhasil dipesan oleh pengguna lain. Periksa detail pesananmu.',
      'time': 'Kemarin',
      'icon': Icons.sell_outlined,
      'color': Color(0xFFE69A00),
      'category': 'Penjualan',
      'read': true,
    },
    {
      'title': 'Temukan Buku Favoritmu!',
      'message':
          'Jelajahi koleksi buku menarik dan temukan bacaan baru di BookCycle.',
      'time': '2 hari lalu',
      'icon': Icons.menu_book_outlined,
      'color': Color(0xFF8E63CE),
      'category': 'Informasi',
      'read': true,
    },
    {
      'title': 'Selamat Datang di BookCycle',
      'message':
          'Jual, beli, dan tukarkan buku favoritmu dengan mudah melalui BookCycle.',
      'time': '3 hari lalu',
      'icon': Icons.waving_hand_outlined,
      'color': Color(0xFF087F3E),
      'category': 'Informasi',
      'read': true,
    },
  ];

  List<Map<String, dynamic>> get filteredNotifications {
    if (selectedFilter == 'Belum dibaca') {
      return notifications
          .where((item) => item['read'] == false)
          .toList();
    }

    return notifications;
  }

  int get unreadCount {
    return notifications
        .where((item) => item['read'] == false)
        .length;
  }

  void markAllAsRead() {
    setState(() {
      for (final item in notifications) {
        item['read'] = true;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Semua notifikasi telah dibaca.'),
      ),
    );
  }

  void markAsRead(Map<String, dynamic> item) {
    setState(() {
      item['read'] = true;
    });

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: Row(
            children: [
              Icon(
                item['icon'] as IconData,
                color: item['color'] as Color,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  item['title'] as String,
                  style: const TextStyle(fontSize: 17),
                ),
              ),
            ],
          ),
          content: Text(item['message'] as String),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                'Tutup',
                style: TextStyle(
                  color: Color(0xFF087F3E),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = filteredNotifications;

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Notifikasi',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF092B8F),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE1F5E8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$unreadCount belum dibaca',
                    style: const TextStyle(
                      color: Color(0xFF087F3E),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Informasi terbaru tentang aktivitas bukumu.',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // FILTER DAN TANDAI SEMUA DIBACA
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilter('Semua'),
                        const SizedBox(width: 8),
                        _buildFilter('Belum dibaca'),
                      ],
                    ),
                  ),
                ),
                TextButton(
                  onPressed:
                      unreadCount > 0 ? markAllAsRead : null,
                  child: const Text(
                    'Baca semua',
                    style: TextStyle(
                      color: Color(0xFF087F3E),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // DAFTAR NOTIFIKASI
          Expanded(
            child: items.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                      16,
                      8,
                      16,
                      20,
                    ),
                    itemCount: items.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final isUnread = item['read'] == false;

                      return Material(
                        color: isUnread
                            ? const Color(0xFFF0F8F3)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () => markAsRead(item),
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isUnread
                                    ? const Color(0xFFD3EBDD)
                                    : const Color(0xFFEEEEEE),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: (item['color'] as Color)
                                        .withValues(alpha: 0.12),
                                    borderRadius:
                                        BorderRadius.circular(14),
                                  ),
                                  child: Icon(
                                    item['icon'] as IconData,
                                    color: item['color'] as Color,
                                    size: 25,
                                  ),
                                ),

                                const SizedBox(width: 12),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              item['title'] as String,
                                              style: TextStyle(
                                                color: const Color(
                                                  0xFF092B8F,
                                                ),
                                                fontSize: 14,
                                                fontWeight: isUnread
                                                    ? FontWeight.bold
                                                    : FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          if (isUnread)
                                            Container(
                                              width: 8,
                                              height: 8,
                                              margin:
                                                  const EdgeInsets.only(
                                                left: 6,
                                                top: 5,
                                              ),
                                              decoration:
                                                  const BoxDecoration(
                                                color: Color(
                                                  0xFF087F3E,
                                                ),
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                        ],
                                      ),

                                      const SizedBox(height: 6),

                                      Text(
                                        item['message'] as String,
                                        style: const TextStyle(
                                          color: Color(0xFF737373),
                                          fontSize: 12,
                                          height: 1.5,
                                        ),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),

                                      const SizedBox(height: 9),

                                      Row(
                                        children: [
                                          Icon(
                                            Icons.access_time,
                                            size: 13,
                                            color: Colors.grey.shade500,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            item['time'] as String,
                                            style: TextStyle(
                                              color:
                                                  Colors.grey.shade600,
                                              fontSize: 11,
                                            ),
                                          ),
                                          const Spacer(),
                                          Text(
                                            isUnread
                                                ? 'Belum dibaca'
                                                : 'Sudah dibaca',
                                            style: TextStyle(
                                              color: isUnread
                                                  ? const Color(
                                                      0xFF087F3E,
                                                    )
                                                  : Colors.grey,
                                              fontSize: 10,
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
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilter(String label) {
    final isSelected = selectedFilter == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 9,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF087F3E)
              : const Color(0xFFF2F4F7),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : const Color(0xFF555555),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: Color(0xFFEAF6EE),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_none,
                size: 52,
                color: Color(0xFF087F3E),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Tidak ada notifikasi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF092B8F),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Semua informasi terbaru akan muncul di sini.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
