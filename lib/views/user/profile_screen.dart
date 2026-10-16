
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/auth_controller.dart';
import '../book/sell_book_screen.dart';
import 'order_history_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const Color blue = Color(0xFF092B8F);
  static const Color green = Color(0xFF087F3E);
  static const Color grey = Color(0xFF78909C);
  static const Color lightGreen = Color(0xFFE2F5EC);

  void _openPage(
    BuildContext context, {
    required Widget page,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AuthController>();
    final user = authController.currentUser;

    final namaPengguna = user?.namaLengkap ?? 'Nama Pengguna';
    final emailPengguna = user?.email ?? 'email@example.com';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
          children: [
            // PROFIL PENGGUNA
            Row(
              children: [
                Container(
                  width: 76,
                  height: 76,
                  decoration: const BoxDecoration(
                    color: lightGreen,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    color: green,
                    size: 52,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        namaPengguna,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: blue,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        emailPengguna,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: grey,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Pengaturan',
                  onPressed: () => _openPage(
                    context,
                    page: const SettingsScreen(),
                  ),
                  icon: const Icon(
                    Icons.settings_outlined,
                    color: blue,
                    size: 30,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // PESANAN SAYA
            _menuItem(
              icon: Icons.assignment_outlined,
              title: 'Pesanan Saya',
              onTap: () => _openPage(
                context,
                page: const OrderHistoryScreen(),
              ),
            ),

            // BUKU SAYA
            _menuItem(
              icon: Icons.book_outlined,
              title: 'Buku Saya',
              onTap: () => _openPage(
                context,
                page: const ProfileMenuPage(
                  title: 'Buku Saya',
                  description:
                      'Daftar buku yang kamu unggah akan ditampilkan di sini.',
                  icon: Icons.book_outlined,
                ),
              ),
            ),

            // JUAL BUKU
            _menuItem(
              icon: Icons.swap_horiz_rounded,
              title: 'Jual Buku',
              onTap: () => _openPage(
                context,
                page: const SellBookScreen(),
              ),
            ),

            // TUKAR BUKU
            _menuItem(
              icon: Icons.local_mall_outlined,
              title: 'Tukar Buku',
              onTap: () => _openPage(
                context,
                page: const ProfileMenuPage(
                  title: 'Tukar Buku',
                  description:
                      'Informasi pertukaran buku BookCycle.',
                  icon: Icons.swap_horiz_rounded,
                ),
              ),
            ),

            // PENGATURAN
            _menuItem(
              icon: Icons.settings_outlined,
              title: 'Pengaturan',
              onTap: () => _openPage(
                context,
                page: const SettingsScreen(),
              ),
            ),

            // BANTUAN
            _menuItem(
              icon: Icons.info_outline_rounded,
              title: 'Bantuan',
              onTap: () => _openPage(
                context,
                page: const HelpScreen(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            height: 64,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 4,
                vertical: 8,
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 42,
                    child: Icon(
                      icon,
                      color: blue,
                      size: 27,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: blue,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: blue,
                    size: 26,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ==================================================
// HALAMAN INFORMASI UNTUK MENU YANG BELUM TERHUBUNG
// ==================================================

class ProfileMenuPage extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const ProfileMenuPage({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
  });

  static const Color blue = Color(0xFF092B8F);
  static const Color green = Color(0xFF087F3E);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            color: blue,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: blue,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: const BoxDecoration(
                  color: Color(0xFFE9F6EF),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: green, size: 45),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: blue,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================================================
// HALAMAN PENGATURAN
// ==================================================

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const Color blue = Color(0xFF092B8F);
  static const Color green = Color(0xFF087F3E);

  bool notificationsEnabled = true;
  bool darkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    final background = darkModeEnabled
        ? const Color(0xFF17212B)
        : const Color(0xFFF7F9FC);

    final cardColor = darkModeEnabled
        ? const Color(0xFF263442)
        : Colors.white;

    final textColor = darkModeEnabled ? Colors.white : blue;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text('Pengaturan'),
        backgroundColor: cardColor,
        foregroundColor: textColor,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Preferensi Aplikasi',
            style: TextStyle(
              color: green,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          Card(
            color: cardColor,
            child: SwitchListTile(
              secondary: const Icon(
                Icons.notifications_outlined,
                color: green,
              ),
              title: Text(
                'Notifikasi',
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                'Aktifkan pemberitahuan aplikasi',
                style: TextStyle(
                  color: darkModeEnabled
                      ? Colors.white70
                      : Colors.blueGrey,
                ),
              ),
              value: notificationsEnabled,
              activeColor: green,
              onChanged: (value) {
                setState(() {
                  notificationsEnabled = value;
                });
              },
            ),
          ),

          Card(
            color: cardColor,
            child: SwitchListTile(
              secondary: const Icon(
                Icons.dark_mode_outlined,
                color: green,
              ),
              title: Text(
                'Mode Gelap',
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                'Ubah tampilan halaman pengaturan',
                style: TextStyle(
                  color: darkModeEnabled
                      ? Colors.white70
                      : Colors.blueGrey,
                ),
              ),
              value: darkModeEnabled,
              activeColor: green,
              onChanged: (value) {
                setState(() {
                  darkModeEnabled = value;
                });
              },
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            'Tentang Aplikasi',
            style: TextStyle(
              color: green,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          Card(
            color: cardColor,
            child: ListTile(
              leading: const Icon(
                Icons.menu_book_rounded,
                color: green,
                size: 34,
              ),
              title: Text(
                'BookCycle',
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: const Text(
                'Buku yang kamu punya, mungkin sedang dicari orang lain.',
              ),
            ),
          ),

          Card(
            color: cardColor,
            child: ListTile(
              leading: const Icon(
                Icons.info_outline,
                color: green,
              ),
              title: Text(
                'Versi Aplikasi',
                style: TextStyle(color: textColor),
              ),
              subtitle: Text(
                'BookCycle 1.0.0',
                style: TextStyle(
                  color: darkModeEnabled
                      ? Colors.white70
                      : Colors.blueGrey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==================================================
// HALAMAN BANTUAN DAN FAQ
// ==================================================

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  static const Color blue = Color(0xFF092B8F);
  static const Color green = Color(0xFF087F3E);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: const Text('Bantuan'),
        backgroundColor: Colors.white,
        foregroundColor: blue,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: green,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.support_agent_rounded,
                  color: Colors.white,
                  size: 44,
                ),
                SizedBox(height: 12),
                Text(
                  'Pusat Bantuan BookCycle',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Temukan panduan untuk menggunakan aplikasi BookCycle.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            'Pertanyaan yang Sering Diajukan',
            style: TextStyle(
              color: blue,
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          _helpItem(
            icon: Icons.person_outline,
            title: 'Bagaimana cara mengubah profil?',
            answer:
                'Buka menu Profil untuk melihat informasi akun. '
                'Fitur perubahan data perlu dihubungkan ke halaman Edit Profil.',
          ),

          _helpItem(
            icon: Icons.add_circle_outline,
            title: 'Bagaimana cara menjual buku?',
            answer:
                'Buka menu Jual Buku, isi judul, penulis, kondisi, '
                'harga, deskripsi, dan foto buku sesuai formulir yang tersedia. '
                'Kemudian simpan buku.',
          ),

          _helpItem(
            icon: Icons.menu_book_outlined,
            title: 'Bagaimana cara melihat buku saya?',
            answer:
                'Buka menu Buku Saya. Daftar buku milikmu akan '
                'tersedia setelah halaman tersebut terhubung ke database.',
          ),

          _helpItem(
            icon: Icons.receipt_long_outlined,
            title: 'Di mana melihat pesanan?',
            answer:
                'Buka menu Pesanan Saya pada halaman Profil untuk '
                'membuka halaman riwayat pesanan.',
          ),

          _helpItem(
            icon: Icons.lock_outline,
            title: 'Bagaimana menjaga keamanan akun?',
            answer:
                'Jangan membagikan kata sandi kepada orang lain. '
                'Gunakan akun sendiri dan hindari menyimpan kata sandi '
                'di perangkat umum.',
          ),

          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFDCEBE3),
              ),
            ),
            child: const Column(
              children: [
                Icon(
                  Icons.mail_outline,
                  color: green,
                  size: 32,
                ),
                SizedBox(height: 8),
                Text(
                  'Masih membutuhkan bantuan?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: blue,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Hubungi pengelola BookCycle melalui kontak resmi '
                  'aplikasi jika tersedia.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _helpItem({
    required IconData icon,
    required String title,
    required String answer,
  }) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(
          color: Color(0xFFE1ECE7),
        ),
      ),
      child: ExpansionTile(
        leading: Icon(icon, color: green),
        iconColor: green,
        collapsedIconColor: blue,
        title: Text(
          title,
          style: const TextStyle(
            color: blue,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(
          16, 0, 16, 16,
        ),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              answer,
              style: const TextStyle(
                color: Colors.blueGrey,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
