import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../controllers/auth_controller.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameC = TextEditingController();
  final _emailC = TextEditingController();
  final _phoneC = TextEditingController();
  final _passC = TextEditingController();

  bool _hidePass = true;

  static const Color _green = Color(0xFF1B6B3A);
  static const Color _darkGreen = Color(0xFF1B5E20);

  @override
  void dispose() {
    _nameC.dispose();
    _emailC.dispose();
    _phoneC.dispose();
    _passC.dispose();
    super.dispose();
  }

  // ---------- VALIDASI ----------
  String? _validateName(String? v) {
    if (v == null || v.trim().isEmpty) return 'Nama lengkap wajib diisi';
    if (v.trim().length < 3) return 'Nama minimal 3 karakter';
    return null;
  }

  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email wajib diisi';
    final ok = RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[a-zA-Z]{2,}$')
        .hasMatch(v.trim());
    if (!ok) return 'Format email tidak valid';
    return null;
  }

  /// Nomor HP Indonesia: 08xx..., 628xx..., atau +628xx...
  String? _validatePhone(String? v) {
    if (v == null || v.trim().isEmpty) return 'Nomor HP wajib diisi';
    final phone = v.trim().replaceAll(RegExp(r'[\s\-]'), '');
    final ok = RegExp(r'^(\+62|62|0)8[1-9][0-9]{7,10}$').hasMatch(phone);
    if (!ok) {
      return 'Nomor HP tidak valid (contoh: 081234567890)';
    }
    return null;
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Password wajib diisi';
    if (v.length < 6) return 'Password minimal 6 karakter';
    return null;
  }

  // ---------- AKSI ----------
  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    final controller = context.read<AuthController>();
    final success = await controller.register(
      email: _emailC.text.trim(),
      password: _passC.text,
      namaLengkap: _nameC.text.trim(),
      nomorHp: _phoneC.text.trim().replaceAll(RegExp(r'[\s\-]'), ''),
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pendaftaran berhasil, silakan login'),
          backgroundColor: _green,
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(controller.errorMessage ?? 'Pendaftaran gagal'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _goToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  // ---------- UI ----------
  InputDecoration _decoration({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.poppins(fontSize: 13, color: Colors.grey),
      prefixIcon: Icon(icon, color: _green, size: 22),
      suffixIcon: suffix,
      contentPadding: const EdgeInsets.symmetric(vertical: 12),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFBDBDBD)),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: _green, width: 1.5),
      ),
      errorBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 1.5),
      ),
      errorStyle: GoogleFonts.poppins(fontSize: 11),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Logo
                    ColorFiltered(
                      colorFilter: const ColorFilter.matrix(<double>[
                        1,
                        0,
                        0,
                        0,
                        0,
                        0,
                        1,
                        0,
                        0,
                        0,
                        0,
                        0,
                        1,
                        0,
                        0,
                        -1.8,
                        0,
                        0,
                        0,
                        459,
                      ]),
                      child: Image.asset(
                        'assets/images/logo.jpg.jpeg',
                        width: 80,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.auto_stories,
                          color: _green,
                          size: 80,
                        ),
                      ),
                    ),
                    Text(
                      'BookCycle',
                      style: GoogleFonts.poppins(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: _darkGreen,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Judul
                    Text(
                      'Daftar Akun Baru',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Mulai perjalanan bukumu di sini!',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: const Color(0xFF1F3A5F),
                      ),
                    ),
                    const SizedBox(height: 22),

                    // Nama lengkap
                    TextFormField(
                      controller: _nameC,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      validator: _validateName,
                      style: GoogleFonts.poppins(fontSize: 14),
                      decoration: _decoration(
                        hint: 'Nama Lengkap',
                        icon: Icons.person_outline,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Email
                    TextFormField(
                      controller: _emailC,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: _validateEmail,
                      style: GoogleFonts.poppins(fontSize: 14),
                      decoration: _decoration(
                        hint: 'Email',
                        icon: Icons.mail_outline,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Nomor HP
                    TextFormField(
                      controller: _phoneC,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      maxLength: 15,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9+]')),
                      ],
                      validator: _validatePhone,
                      style: GoogleFonts.poppins(fontSize: 14),
                      decoration: _decoration(
                        hint: 'Nomor HP',
                        icon: Icons.phone_iphone_outlined,
                      ).copyWith(counterText: ''),
                    ),
                    const SizedBox(height: 6),

                    // Password
                    TextFormField(
                      controller: _passC,
                      obscureText: _hidePass,
                      textInputAction: TextInputAction.done,
                      validator: _validatePassword,
                      onFieldSubmitted: (_) => _register(),
                      style: GoogleFonts.poppins(fontSize: 14),
                      decoration: _decoration(
                        hint: 'Password',
                        icon: Icons.lock_outline,
                        suffix: IconButton(
                          icon: Icon(
                            _hidePass
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: _green,
                            size: 22,
                          ),
                          onPressed: () =>
                              setState(() => _hidePass = !_hidePass),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Tombol Daftar (status loading dari AuthController)
                    Consumer<AuthController>(
                      builder: (context, controller, _) {
                        return SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: controller.isLoading ? null : _register,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _green,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: controller.isLoading
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : Text(
                                    'Daftar',
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 18),

                    Text(
                      'atau daftar dengan',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: const Color(0xFF444444),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Google & Facebook
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _socialButton(
                          label: 'Google',
                          icon: const SizedBox(
                            width: 24,
                            height: 24,
                            child: CustomPaint(painter: GoogleLogoPainter()),
                          ),
                          onTap: () {
                            // TODO: daftar dengan Google
                          },
                        ),
                        const SizedBox(width: 36),
                        _socialButton(
                          label: 'Facebook',
                          icon: const Icon(
                            Icons.facebook,
                            color: Color(0xFF1877F2),
                            size: 26,
                          ),
                          onTap: () {
                            // TODO: daftar dengan Facebook
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),

                    // Sudah punya akun
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Sudah punya akun? ',
                          style: GoogleFonts.poppins(fontSize: 13),
                        ),
                        GestureDetector(
                          onTap: _goToLogin,
                          child: Text(
                            'Login',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: _green,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _socialButton({
    required String label,
    required Widget icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Logo Google "G" 4 warna
class GoogleLogoPainter extends CustomPainter {
  const GoogleLogoPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final sw = size.width * 0.22; // ketebalan garis
    final r = size.width / 2 - sw / 2;
    final rect = Rect.fromCircle(center: c, radius: r);
    double rad(double deg) => deg * 3.1415926535 / 180;

    Paint arc(Color color) => Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = sw
      ..strokeCap = StrokeCap.butt;

    // Merah (atas)
    canvas.drawArc(
      rect,
      rad(200),
      rad(115),
      false,
      arc(const Color(0xFFEA4335)),
    );
    // Kuning (kiri)
    canvas.drawArc(
      rect,
      rad(135),
      rad(65),
      false,
      arc(const Color(0xFFFBBC05)),
    );
    // Hijau (bawah)
    canvas.drawArc(rect, rad(45), rad(90), false, arc(const Color(0xFF34A853)));
    // Biru (kanan bawah)
    canvas.drawArc(rect, rad(0), rad(45), false, arc(const Color(0xFF4285F4)));

    // Garis tengah biru pada huruf G
    canvas.drawRect(
      Rect.fromLTRB(c.dx, c.dy - sw / 2, size.width, c.dy + sw / 2),
      Paint()..color = const Color(0xFF4285F4),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
