import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/auth_controller.dart'; // ✅ Perbaiki path ke controllers
import 'login_screen.dart'; // ✅ Karena satu folder, cukup nama file
import '../user/home_screen.dart'; // ✅ Naik 1 folder (views), lalu masuk user

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    final authController = Provider.of<AuthController>(context, listen: false);
    await authController.loadCurrentUser();

    if (!mounted) return;

    if (authController.isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: 190,
                height: 190,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.auto_stories,
                    color: Color(0xFF087F3E),
                    size: 120,
                  );
                },
              ),
              const SizedBox(height: 5),
              const Text(
                'Buku yang kamu punya,\nmungkin sedang dicari oleh orang lain.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF087F3E),
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'BookCycle',
                style: TextStyle(
                  color: Color(0xFF087F3E),
                  fontSize: 38,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
