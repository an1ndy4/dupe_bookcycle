import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'register_screen.dart'; // juga membawa GoogleLogoPainter

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _idC = TextEditingController();
  final _passC = TextEditingController();

  bool _hidePass = true;
  bool _loading = false;

  static const Color _green = Color(0xFF1B6B3A);
  static const Color _darkGreen = Color(0xFF1B5E20);

  @override
  void dispose() {
    _idC.dispose();
    _passC.dispose();
    super.dispose();
  }

  // ---------- VALIDASI ----------
  String? _validateId(String? v) {
    if (v == null || v.trim().isEmpty) {
      return 'Email atau Nomor HP wajib diisi';
    }
    final value = v.trim().replaceAll(RegExp(r'[\s\-]'), '');
    final isEmail = RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[a-zA-Z]{2,}$')
        .hasMatch(value);
    final isPhone = RegExp(r'^(\+62|62|0)8[1-9][0-9]{7,10}$').hasMatch(value);
    if (!isEmail && !isPhone) {
      return 'Masukkan email atau nomor HP yang valid';
    }
    return null;
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Password wajib diisi';
    if (v.length < 6) return 'Password minimal 6 karakter';
    return null;
  }

  // ---------- AKSI ----------
  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    // TODO: hubungkan ke Supabase di sini, contoh:
    // await Supabase.instance.client.auth.signInWithPassword(
    //   email: _idC.text.trim(),
    //   password: _passC.text,
    // );
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;
    setState(() => _loading = false);

    // TODO: pindah ke halaman utama setelah login berhasil
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Login berhasil')));
  }

  void _goToRegister() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const RegisterScreen()),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Logo + nama aplikasi (di tengah)
                    Center(
                      child: Column(
                        children: [
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
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),

                    // Judul (rata kiri)
                    Text(
                      'Selamat datang kembali!',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Login untuk melanjutkan.',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: const Color(0xFF1F3A5F),
                      ),
                    ),
                    const SizedBox(height: 22),

                    // Email / Nomor HP
                    TextFormField(
                      controller: _idC,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: _validateId,
                      style: GoogleFonts.poppins(fontSize: 14),
                      decoration: _decoration(
                        hint: 'Email/Nomor HP',
                        icon: Icons.mail_outline,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Password
                    TextFormField(
                      controller: _passC,
                      obscureText: _hidePass,
                      textInputAction: TextInputAction.done,
                      validator: _validatePassword,
                      onFieldSubmitted: (_) => _login(),
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
                    const SizedBox(height: 12),

                    // Lupa password
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          // TODO: halaman lupa password
                        },
                        child: Text(
                          'Lupa Password?',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: _green,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Tombol Login
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _loading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: _loading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : Text(
                                'Login',
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 18),

                    Center(
                      child: Text(
                        'atau masuk dengan',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: const Color(0xFF444444),
                        ),
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
                            // TODO: login dengan Google
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
                            // TODO: login dengan Facebook
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),

                    // Belum punya akun
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Belum punya akun? ',
                            style: GoogleFonts.poppins(fontSize: 13),
                          ),
                          GestureDetector(
                            onTap: _goToRegister,
                            child: Text(
                              'Daftar sekarang',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: _green,
                              ),
                            ),
                          ),
                        ],
                      ),
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
