import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/auth_controller.dart';
import '../user/home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _passwordVisible = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    final authController = Provider.of<AuthController>(context, listen: false);

    // PERBAIKAN: 'namaLengkap' (huruf L besar) sesuai dengan auth_controller.dart
    final success = await authController.register(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      namaLengkap: _nameController.text.trim(),
      nomorHp: _phoneController.text.trim().isEmpty
          ? null
          : _phoneController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registrasi Berhasil! Silakan Login.'),
          backgroundColor: Color(0xFF087F3E),
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authController.errorMessage ?? 'Registrasi gagal'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  Center(
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 80,
                      height: 80,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.auto_stories,
                        color: Color(0xFF087F3E),
                        size: 65,
                      ),
                    ),
                  ),
                  const Center(
                    child: Text(
                      'BookCycle',
                      style: TextStyle(
                        color: Color(0xFF087F3E),
                        fontSize: 29,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    'Daftar Akun Baru',
                    style: TextStyle(
                      color: Color(0xFF092B8F),
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Mulai perjalanan bukumu di sini!',
                    style: TextStyle(color: Color(0xFF092B8F), fontSize: 16),
                  ),
                  const SizedBox(height: 30),
                  _buildInputField(
                    controller: _nameController,
                    icon: Icons.person_outline,
                    hint: 'Nama Lengkap',
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Nama harus diisi';
                      if (value.length < 3) return 'Nama minimal 3 karakter';
                      return null;
                    },
                  ),
                  _buildInputField(
                    controller: _emailController,
                    icon: Icons.email_outlined,
                    hint: 'Email',
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Email harus diisi';
                      if (!value.contains('@') || !value.contains('.'))
                        return 'Format email tidak valid';
                      return null;
                    },
                  ),
                  _buildInputField(
                    controller: _phoneController,
                    icon: Icons.phone_outlined,
                    hint: 'Nomor HP (Opsional)',
                    validator: (value) {
                      if (value != null &&
                          value.isNotEmpty &&
                          value.length < 10) {
                        return 'Nomor HP tidak valid';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_passwordVisible,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: const TextStyle(
                        color: Color(0xFFB7C9EA),
                        fontSize: 13,
                      ),
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: Color(0xFF092B8F),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: const Color(0xFF092B8F),
                        ),
                      ),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFDDE4F0)),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF087F3E)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Password harus diisi';
                      if (value.length < 6)
                        return 'Password minimal 6 karakter';
                      return null;
                    },
                  ),
                  const SizedBox(height: 25),
                  Consumer<AuthController>(
                    builder: (context, controller, _) {
                      return SizedBox(
                        width: double.infinity,
                        height: 47,
                        child: ElevatedButton(
                          onPressed: controller.isLoading
                              ? null
                              : _handleRegister,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF087F3E),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7),
                            ),
                          ),
                          child: controller.isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Daftar',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 17),
                  const Center(
                    child: Text(
                      'atau daftar dengan',
                      style: TextStyle(color: Color(0xFF092B8F), fontSize: 13),
                    ),
                  ),
                  const SizedBox(height: 14),
                  // BAGIAN TOMBOL SOSIAL YANG SUDAH DIPERBAIKI POSISINYA
                  Row(
                    children: [
                      Expanded(
                        child: _buildSocialButton(
                          logo: _buildGoogleLogo(),
                          label: 'Google',
                          onTap: () {
                            // TODO: Implement Google Sign-In
                          },
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: _buildSocialButton(
                          logo: _buildFacebookLogo(),
                          label: 'Facebook',
                          onTap: () {
                            // TODO: Implement Facebook Login
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Sudah punya akun?',
                          style: TextStyle(
                            color: Color(0xFF092B8F),
                            fontSize: 13,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              color: Color(0xFF149447),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // =========================================================
  //  AREA METHOD HELPER (DITAMBAHKAN DI SINI)
  // =========================================================

  Widget _buildInputField({
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFFB7C9EA), fontSize: 13),
          prefixIcon: Icon(icon, color: const Color(0xFF092B8F), size: 21),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFDDE4F0)),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF087F3E)),
          ),
        ),
        validator: validator,
      ),
    );
  }

  // 1. Method untuk Logo Google
  // ✅ Logo Google Berwarna-warni (seperti logo asli)
  Widget _buildGoogleLogo() {
    return SizedBox(
      width: 22,
      height: 22,
      child: CustomPaint(painter: GoogleLogoPainter()),
    );
  }

  // 2. Method untuk Logo Facebook
  Widget _buildFacebookLogo() {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: const Color(0xFF1877F2),
        borderRadius: BorderRadius.circular(3),
      ),
      child: const Icon(Icons.facebook, color: Colors.white, size: 14),
    );
  }

  // 3. Method untuk Tombol Social (Kotak Berborder)
  Widget _buildSocialButton({
    required Widget logo,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 47,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFDDE4F0)),
          borderRadius: BorderRadius.circular(7),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            logo,
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF092B8F),
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
} // <--- INI ADALAH PENUTUP CLASS _RegisterScreenState

// ✅ Custom Painter untuk Logo Google Berwarna
class GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double radius = size.width / 2;

    // Warna resmi Google
    const Color red = Color(0xFFEA4335);
    const Color yellow = Color(0xFFFBBC05);
    const Color green = Color(0xFF34A853);
    const Color blue = Color(0xFF4285F4);

    final Paint paint = Paint()..style = PaintingStyle.fill;

    // Gambar huruf "G" dengan 4 warna menggunakan arc
    // Bagian atas (merah) - dari 0° sampai 90°
    paint.color = red;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
      -0.3, // mulai dari sedikit di atas
      1.2, // arc length
      true,
      paint,
    );

    // Bagian kanan (kuning)
    paint.color = yellow;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
      0.9,
      1.2,
      true,
      paint,
    );

    // Bagian bawah (hijau)
    paint.color = green;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
      2.1,
      1.2,
      true,
      paint,
    );

    // Bagian kiri (biru)
    paint.color = blue;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
      3.3,
      1.2,
      true,
      paint,
    );

    // Gambar huruf "G" putih di tengah (untuk efek logo)
    final TextPainter textPainter = TextPainter(
      text: const TextSpan(
        text: 'G',
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          fontFamily: 'Arial',
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(centerX - textPainter.width / 2, centerY - textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
