import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/auth_controller.dart';
import '../auth/login_screen.dart';

import 'order_history_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const Color green = Color(0xFF087F3E);
  static const Color blue = Color(0xFF092B8F);

  @override
  Widget build(BuildContext context) {
    final authController =
        Provider.of<AuthController>(context);

    final user =
        authController.currentUser;

    return SafeArea(
      child: SingleChildScrollView(
        padding:
            const EdgeInsets.fromLTRB(
          18,
          10,
          18,
          20,
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [

                const Text(
                  'Profil',
                  style: TextStyle(
                    color: blue,
                    fontSize: 21,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                IconButton(
                  onPressed: () {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Pengaturan akan segera tersedia.',
                        ),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.settings_outlined,
                    color: blue,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color:
                    const Color(0xFFF2F7FF),
                borderRadius:
                    BorderRadius.circular(17),
              ),
              child: Row(
                children: [

                  // FOTO
                  Container(
                    width: 62,
                    height: 62,
                    decoration:
                        const BoxDecoration(
                      color: green,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),

                  const SizedBox(width: 14),

                  // NAMA
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [

                        Text(
                          user?.namaLengkap ??
                              'Siti Nurhaliza',
                          maxLines: 1,
                          overflow:
                              TextOverflow.ellipsis,
                          style:
                              const TextStyle(
                            color: blue,
                            fontSize: 17,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          user?.email ??
                              'sitinurhaliza@gmail.com',
                          maxLines: 1,
                          overflow:
                              TextOverflow.ellipsis,
                          style:
                              const TextStyle(
                            color: Colors.grey,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            _menuItem(
              context: context,
              icon: Icons.shopping_bag_outlined,
              title: 'Pesanan Saya',
              subtitle:
                  'Lihat pesanan dan status pengiriman',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const OrderHistoryScreen(),
                  ),
                );
              },
            ),

            _menuItem(
              context: context,
              icon: Icons.menu_book_outlined,
              title: 'Buku Saya',
              subtitle:
                  'Buku yang kamu miliki',
              onTap: () {
                _showMessage(
                  context,
                  'Fitur Buku Saya akan segera tersedia.',
                );
              },
            ),

            _menuItem(
              context: context,
              icon: Icons.sell_outlined,
              title: 'Jual Buku',
              subtitle:
                  'Kelola buku yang kamu jual',
              onTap: () {
                _showMessage(
                  context,
                  'Fitur Jual Buku akan segera tersedia.',
                );
              },
            ),

            _menuItem(
              context: context,
              icon: Icons.swap_horiz,
              title: 'Tukar Buku',
              subtitle:
                  'Kelola buku untuk ditukar',
              onTap: () {
                _showMessage(
                  context,
                  'Fitur Tukar Buku akan segera tersedia.',
                );
              },
            ),

            _menuItem(
              context: context,
              icon: Icons.settings_outlined,
              title: 'Pengaturan',
              subtitle:
                  'Pengaturan akun BookCycle',
              onTap: () {
                _showMessage(
                  context,
                  'Fitur Pengaturan akan segera tersedia.',
                );
              },
            ),

            _menuItem(
              context: context,
              icon: Icons.help_outline,
              title: 'Bantuan',
              subtitle:
                  'Bantuan penggunaan BookCycle',
              onTap: () {
                _showMessage(
                  context,
                  'Pusat Bantuan akan segera tersedia.',
                );
              },
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              height: 46,
              child: OutlinedButton.icon(
                onPressed: () async {

                  await authController.logout();

                  if (!context.mounted) {
                    return;
                  }

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const LoginScreen(),
                    ),
                    (route) => false,
                  );
                },

                icon: const Icon(
                  Icons.logout,
                  size: 18,
                ),

                label: const Text(
                  'Logout',
                  style: TextStyle(
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                style:
                    OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side:
                      const BorderSide(
                    color: Colors.red,
                  ),
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      10,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin:
          const EdgeInsets.only(bottom: 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(13),
        border: Border.all(
          color: const Color(0xFFE4E9F1),
        ),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(
          horizontal: 13,
          vertical: 2,
        ),

        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color:
                const Color(0xFFEFF8F3),
            borderRadius:
                BorderRadius.circular(11),
          ),
          child: Icon(
            icon,
            color: green,
            size: 22,
          ),
        ),

        title: Text(
          title,
          style: const TextStyle(
            color: blue,
            fontSize: 13,
            fontWeight:
                FontWeight.bold,
          ),
        ),

        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 9,
          ),
        ),

        trailing: const Icon(
          Icons.chevron_right,
          color: Colors.grey,
          size: 21,
        ),

        onTap: onTap,
      ),
    );
  }

  void _showMessage(
    BuildContext context,
    String message,
  ) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}