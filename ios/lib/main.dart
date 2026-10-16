import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/supabase_service.dart';
import 'controllers/auth_controller.dart';
import 'controllers/book_controller.dart';
import 'controllers/category_controller.dart';

// ✅ PERBAIKI: Tambahkan folder 'auth/' dan 'book/' sesuai struktur folder kamu
import 'views/auth/splash_screen.dart';
import 'views/auth/login_screen.dart';
import 'views/auth/register_screen.dart';
import 'views/user/home_screen.dart';
import 'views/user/profile_screen.dart';
import 'views/book/book_detail_screen.dart';
import 'views/book/sell_book_screen.dart'; // ✅ Ganti upload_book_screen dengan sell_book_screen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService.initialize();
  runApp(const BookCycleApp());
}

class BookCycleApp extends StatelessWidget {
  const BookCycleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => BookController()),
        ChangeNotifierProvider(create: (_) => CategoryController()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'BookCycle',
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.white,
          fontFamily: 'Arial',
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF087F3E),
            primary: const Color(0xFF087F3E),
            secondary: const Color(0xFF092B8F),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/home': (context) => const HomeScreen(),
          // ✅ DIHAPUS: '/book-detail' tidak bisa ada di routes karena butuh parameter 'book'
          '/upload-book': (context) =>
              SellBookScreen(), // ✅ Gunakan SellBookScreen
          '/profile': (context) => const ProfileScreen(),
        },
      ),
    );
  }
}
