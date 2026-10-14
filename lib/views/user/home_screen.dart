
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/book_controller.dart';
import '../../controllers/category_controller.dart';
import '../book/sell_book_screen.dart';
import '../widgets/book_card.dart';
import 'category_books_screen.dart';
import 'notification_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const Color green = Color(0xFF087F3E);
  static const Color blue = Color(0xFF092B8F);

  final TextEditingController _searchController =
      TextEditingController();

  int _currentIndex = 0;

  final List<Map<String, dynamic>> _categories = [
    {
      'name': 'Fiksi',
      'id': 1,
      'icon': Icons.menu_book_rounded,
      'bg': Color(0xFFE0F4E9),
      'fg': Color(0xFF087F3E),
    },
    {
      'name': 'Non Fiksi',
      'id': 2,
      'icon': Icons.card_giftcard_rounded,
      'bg': Color(0xFFE0F0FC),
      'fg': Color(0xFF159BD7),
    },
    {
      'name': 'Pelajaran',
      'id': 3,
      'icon': Icons.menu_book_rounded,
      'bg': Color(0xFFE0F4E9),
      'fg': Color(0xFF087F3E),
    },
    {
      'name': 'Komik',
      'id': 4,
      'icon': Icons.bookmark_rounded,
      'bg': Color(0xFFFCE4E7),
      'fg': Color(0xFFE84D68),
    },
    {
      'name': 'Self Help',
      'id': 5,
      'icon': Icons.self_improvement_rounded,
      'bg': Color(0xFFFFEDCF),
      'fg': Color(0xFFD99400),
    },
    {
      'name': 'Teknologi',
      'id': 6,
      'icon': Icons.psychology_rounded,
      'bg': Color(0xFFE0F0FC),
      'fg': Color(0xFF159BD7),
    },
    {
      'name': 'Bisnis',
      'id': 7,
      'icon': Icons.business_center_rounded,
      'bg': Color(0xFFFFE9CA),
      'fg': Color(0xFFE47712),
    },
    {
      'name': 'Lainnya',
      'id': 8,
      'icon': Icons.grid_view_rounded,
      'bg': Color(0xFFE0F0FC),
      'fg': Color(0xFF159BD7),
    },
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<BookController>().fetchAllBooks();
      context.read<CategoryController>().fetchAllCategories();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _searchBooks(String query) {
    context.read<BookController>().searchBooks(query);
  }

  // Navigasi ke halaman buku berdasarkan kategori.
  void _openCategory(int kategoriId, String namaKategori) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryScreen(
          kategoriId: kategoriId,
          namaKategori: namaKategori,
        ),
      ),
    );
  }

  void _openSellPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SellBookScreen(),
      ),
    );
  }

  void _onNavigationTap(int index) {
    if (index == 1) {
      _openSellPage();
      return;
    }

    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _currentIndex == 2
            ? NotificationScreen()
            : _currentIndex == 3
                ? ProfileScreen()
                : _buildHomeContent(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onNavigationTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: green,
        unselectedItemColor: blue,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Jual',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none_rounded),
            label: 'Notifikasi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeContent() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(23, 24, 23, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // PENCARIAN
                TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    _searchBooks(value);
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    hintText: 'Cari buku, judul, penulis, atau kategori...',
                    hintStyle: const TextStyle(
                      color: Color(0xFF8799B5),
                      fontSize: 16,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: blue,
                      size: 31,
                    ),
                    suffixIcon: _searchController.text.isEmpty
                        ? null
                        : IconButton(
                            onPressed: () {
                              _searchController.clear();
                              _searchBooks('');
                              setState(() {});
                            },
                            icon: const Icon(Icons.close),
                          ),
                    filled: true,
                    fillColor: const Color(0xFFEEF4FD),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 25,
                      horizontal: 20,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 39),

                // BANNER HIJAU
                Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(minHeight: 245),
                  padding: const EdgeInsets.fromLTRB(30, 32, 20, 28),
                  decoration: BoxDecoration(
                    color: green,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 7,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Buku baru,\ncerita baru!',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                height: 1.2,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'Temukan buku favoritmu\ndengan harga terbaik.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                height: 1.6,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        flex: 3,
                        child: Icon(
                          Icons.menu_book_rounded,
                          size: 83,
                          color: Color(0xFFB9F0D0),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 55),

                // MENU BELI, JUAL, TUKAR
                Row(
                  children: [
                    Expanded(
                      child: _buildAction(
                        icon: Icons.shopping_bag_outlined,
                        label: 'Beli',
                        color: green,
                        onTap: () {
                          _searchController.clear();
                          _searchBooks('');
                          setState(() {});
                        },
                      ),
                    ),
                    Expanded(
                      child: _buildAction(
                        icon: Icons.sell_outlined,
                        label: 'Jual',
                        color: const Color(0xFFFFC629),
                        onTap: _openSellPage,
                      ),
                    ),
                    Expanded(
                      child: _buildAction(
                        icon: Icons.swap_horiz_rounded,
                        label: 'Tukar',
                        color: const Color(0xFF109FE0),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Fitur tukar buku akan segera tersedia.',
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 57),

                // JUDUL KATEGORI
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Kategori',
                      style: TextStyle(
                        color: blue,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Pilih salah satu kategori untuk melihat buku.',
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'Lihat Semua ›',
                        style: TextStyle(
                          color: green,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                // KATEGORI 4 KOLOM X 2 BARIS
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _categories.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 27,
                    childAspectRatio: 0.78,
                  ),
                  itemBuilder: (context, index) {
                    final category = _categories[index];

                    return InkWell(
                      onTap: () {
                        _openCategory(
                          category['id'] as int,
                          category['name'] as String,
                        );
                      },
                      borderRadius: BorderRadius.circular(15),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 78,
                            height: 78,
                            decoration: BoxDecoration(
                              color: category['bg'] as Color,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              category['icon'] as IconData,
                              color: category['fg'] as Color,
                              size: 35,
                            ),
                          ),
                          const SizedBox(height: 11),
                          Text(
                            category['name'] as String,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: blue,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 40),

                // REKOMENDASI BUKU
                const Text(
                  'Rekomendasi Buku',
                  style: TextStyle(
                    color: blue,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),

        // DATA BUKU
        Consumer<BookController>(
          builder: (context, controller, child) {
            if (controller.isLoading) {
              return const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Center(
                    child: CircularProgressIndicator(color: green),
                  ),
                ),
              );
            }

            if (controller.errorMessage != null) {
              return SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: Text(
                      'Gagal memuat buku:\n${controller.errorMessage}',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            }

            final books = controller.books;

            if (books.isEmpty) {
              return const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Center(
                    child: Text(
                      'Belum ada buku yang tersedia.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              );
            }

            return SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 23),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return BookCard(book: books[index]);
                  },
                  childCount: books.length,
                ),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.62,
                ),
              ),
            );
          },
        ),

        const SliverToBoxAdapter(
          child: SizedBox(height: 30),
        ),
      ],
    );
  }

  Widget _buildAction({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(60),
      child: Column(
        children: [
          Container(
            width: 92,
            height: 92,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 39,
            ),
          ),
          const SizedBox(height: 17),
          Text(
            label,
            style: const TextStyle(
              color: blue,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
