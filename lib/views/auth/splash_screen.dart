import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 7), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    // Batasi lebar seperti layar HP, supaya di Chrome tidak membesar
    final w = screen.width > 430 ? 430.0 : screen.width;
    final h = screen.height;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.1),
            radius: 0.85,
            colors: [
              Colors.white,
              Color(0xFFF1F9F1),
              Color(0xFFD5EBD5),
              Color(0xFFB4D9B4),
            ],
            stops: [0.0, 0.35, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: Column(
                children: [
                  const Spacer(flex: 5),

                  // Logo
                  ColorFiltered(
                    colorFilter: const ColorFilter.matrix(<double>[
                      1, 0, 0, 0, 0,
                      0, 1, 0, 0, 0,
                      0, 0, 1, 0, 0,
                      -1.8, 0, 0, 0, 459, // putih jadi transparan
                    ]),
                    child: Image.asset(
                      'assets/images/logo.jpg.jpeg',
                      width: w * 0.32,
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: h * 0.01),

                  // Nama aplikasi
                  Text(
                    'BookCycle',
                    style: GoogleFonts.poppins(
                      fontSize: w * 0.095,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1B5E20),
                    ),
                  ),

                  // Tagline
                  Text(
                    'Buku yang kamu punya,\nmungkin sedang dicari orang lain.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: w * 0.036,
                      height: 1.35,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),

                  const Spacer(flex: 2),

                  // Tumpukan buku
                  SizedBox(
                    width: w * 0.62,
                    child: const AspectRatio(
                      aspectRatio: 210 / 125,
                      child: CustomPaint(painter: BookStackPainter()),
                    ),
                  ),

                  const Spacer(flex: 2),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Tumpukan 3 buku: oranye (bawah), biru (tengah), hijau (atas)
class BookStackPainter extends CustomPainter {
  const BookStackPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 210, size.height / 125);

    // Bayangan
    canvas.drawOval(
      const Rect.fromLTWH(12, 108, 186, 14),
      Paint()
        ..color = const Color(0x40000000)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 7),
    );

    // Oranye (bawah)
    _book(
      canvas,
      x: 6,
      y: 80,
      w: 192,
      h: 30,
      light: const Color(0xFFF58A4A),
      base: const Color(0xFFE8601C),
      dark: const Color(0xFFC24A10),
      spine: const Color(0xFFB04010),
    );

    // Biru (tengah)
    _book(
      canvas,
      x: 24,
      y: 49,
      w: 168,
      h: 30,
      light: const Color(0xFF4A8EDB),
      base: const Color(0xFF1E63B8),
      dark: const Color(0xFF174F96),
      spine: const Color(0xFF123F78),
    );

    // Hijau (atas), sedikit miring
    canvas.save();
    canvas.translate(105, 32);
    canvas.rotate(-0.045);
    canvas.translate(-105, -32);
    _book(
      canvas,
      x: 38,
      y: 18,
      w: 146,
      h: 30,
      light: const Color(0xFF52B06E),
      base: const Color(0xFF1F7A3A),
      dark: const Color(0xFF186230),
      spine: const Color(0xFF12521F),
    );
    canvas.restore();
  }

  void _book(
    Canvas canvas, {
    required double x,
    required double y,
    required double w,
    required double h,
    required Color light,
    required Color base,
    required Color dark,
    required Color spine,
  }) {
    final rect = Rect.fromLTWH(x, y, w, h);

    // Badan buku (gradasi)
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(5)),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [light, base, dark],
          stops: const [0.0, 0.25, 1.0],
        ).createShader(rect),
    );

    // Punggung buku
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(x, y, 11, h),
        topLeft: const Radius.circular(5),
        bottomLeft: const Radius.circular(5),
      ),
      Paint()..color = spine,
    );

    // Halaman buku
    final pages = Rect.fromLTWH(x + w * 0.73, y + 5, w * 0.27 - 4, h - 10);
    canvas.drawRRect(
      RRect.fromRectAndRadius(pages, const Radius.circular(3)),
      Paint()..color = const Color(0xFFF8EFDC),
    );
    final line = Paint()
      ..color = const Color(0xFFD9CCB0)
      ..strokeWidth = 1;
    for (double ly = pages.top + 5; ly < pages.bottom - 2; ly += 5) {
      canvas.drawLine(
        Offset(pages.left + 3, ly),
        Offset(pages.right - 3, ly),
        line,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
