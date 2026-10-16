
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/auth_controller.dart';
import '../auth/login_screen.dart';
import '../book/sell_book_screen.dart';
import 'order_history_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const green = Color(0xFF087F3E);
  static const blue = Color(0xFF092B8F);

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);
    final user = authController.currentUser;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Profil Saya',
                  style: TextStyle(
                    color: blue,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => _message(
                    context,
                    'Pengaturan akan segera tersedia.',
                  ),
                  icon: const Icon(Icons.settings_outlined, color: blue),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFEEF5FF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: const BoxDecoration(
                      color: green,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 38,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.namaLengkap ?? 'Pengguna BookCycle',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: blue,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          user?.email ?? 'Email belum tersedia',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF7D8AA3),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Akun Saya',
              style: TextStyle(
                color: blue,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _menuItem(
              context,
              Icons.shopping_bag_outlined,
              'Pesanan Saya',
              'Lihat riwayat dan status pesanan',
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const OrderHistoryScreen(),
                  ),
                );
              },
            ),
            _menuItem(
              context,
              Icons.menu_book_outlined,
              'Buku Saya',
              'Buku yang kamu miliki',
              () => _message(context, 'Fitur Buku Saya akan segera tersedia.'),
            ),
            _menuItem(
              context,
              Icons.sell_outlined,
              'Jual Buku',
              'Tambahkan buku yang ingin dijual',
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SellBookScreen(),
                  ),
                );
              },
            ),
            _menuItem(
              context,
              Icons.swap_horiz,
              'Tukar Buku',
              'Kelola buku untuk ditukar',
              () => _message(context, 'Fitur Tukar Buku akan segera tersedia.'),
            ),
            _menuItem(
              context,
              Icons.settings_outlined,
              'Pengaturan',
              'Pengaturan akun BookCycle',
              () => _message(context, 'Fitur Pengaturan akan segera tersedia.'),
            ),
            _menuItem(
              context,
              Icons.help_outline,
              'Bantuan',
              'Bantuan penggunaan BookCycle',
              () => _message(context, 'Pusat Bantuan akan segera tersedia.'),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: OutlinedButton.icon(
                onPressed: () async {
                  await authController.logout();

                  if (!context.mounted) return;

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LoginScreen(),
                    ),
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.logout),
                label: const Text(
                  'Logout',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuItem(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFEEF5FF),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: blue, size: 22),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: blue,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: Color(0xFF8A9AB5),
            fontSize: 10,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: blue,
        ),
        onTap: onTap,
      ),
    );
  }

  void _message(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
