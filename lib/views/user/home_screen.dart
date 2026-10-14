
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/book_controller.dart';
import '../../controllers/category_controller.dart';
import '../book/sell_book_screen.dart';
import '../widgets/book_card.dart';
import 'profile_screen.dart';
import 'notification_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final TextEditingController _searchController =
      TextEditingController();

  final List<Map<String, dynamic>> _categories = [
    {
      'name': 'Fiksi',
      'icon': Icons.menu_book_rounded,
      'bg': Color(0xFFE1F5E8),
      'fg': Color(0xFF087F3E),
    },
    {
      'name': 'Non Fiksi',
      'icon': Icons.card_giftcard_rounded,
      'bg': Color(0xFFE0F1FF),
      'fg': Color(0xFF1599E8),
    },
    {
      'name': 'Pelajaran',
      'icon': Icons.menu_book,
      'bg': Color(0xFFDFF5E6),
      'fg': Color(0xFF087F3E),
    },
    {
      'name': 'Komik',
      'icon': Icons.book,
      'bg': Color(0xFFFFE4E4),
      'fg': Color(0xFFE84B65),
    },
    {
      'name': 'Self Help',
      'icon': Icons.self_improvement,
      'bg': Color(0xFFFFEBC7),
      'fg': Color(0xFFE69A00),
    },
    {
      'name': 'Teknologi',
      'icon': Icons.psychology,
      'bg': Color(0xFFDFF1FF),
      'fg': Color(0xFF1599E8),
    },
    {
      'name': 'Bisnis',
      'icon': Icons.business_center,
      'bg': Color(0xFFFFE6C7),
      'fg': Color(0xFFE66A00),
    },
    {
      'name': 'Lainnya',
      'icon': Icons.apps,
      'bg': Color(0xFFDFF1FF),
      'fg': Color(0xFF1599E8),
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

  void _searchBooks(String value) {
    context.read<BookController>().searchBooks(value);
    setState(() {});
  }

  void _openSellPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SellBookScreen(),
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
            ? const NotificationScreen()
            : _currentIndex == 3
                ? ProfileScreen()
                : _buildHomeContent(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onNavigationTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF087F3E),
        unselectedItemColor: const Color(0xFF092B8F),
        selectedFontSize: 12,
        unselectedFontSize: 12,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline, size: 32),
            label: 'Jual',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            activeIcon: Icon(Icons.notifications),
            label: 'Notifikasi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
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
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearchField(),
                const SizedBox(height: 26),
                _buildBanner(),
                const SizedBox(height: 38),
                _buildActionMenu(),
                const SizedBox(height: 38),
                _buildSectionTitle(
                  title: 'Kategori',
                  action: 'Lihat Semua ›',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Daftar kategori BookCycle.'),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                _buildCategories(),
                const SizedBox(height: 28),
                _buildSectionTitle(
                  title: _searchController.text.isEmpty
                      ? 'Rekomendasi Buku'
                      : 'Hasil Pencarian',
                  action: '',
                  onTap: () {},
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
        Consumer<BookController>(
          builder: (context, controller, child) {
            final books = controller.books;

            if (books.isEmpty) {
              return const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 30,
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.menu_book,
                          size: 48,
                          color: Color(0xFF087F3E),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Belum ada buku yang ditampilkan.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            return SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
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
      ],
    );
  }

  Widget _buildSearchField() {
    return Container(
      height: 58,
      decoration: BoxDecoration(
        color: const Color(0xFFEEF5FF),
        borderRadius: BorderRadius.circular(18),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _searchBooks,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: const Icon(
            Icons.search,
            color: Color(0xFF092B8F),
            size: 29,
          ),
          hintText: 'Cari buku, judul, penulis, atau kategori...',
          hintStyle: const TextStyle(
            color: Color(0xFF8296B8),
            fontSize: 14,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Color(0xFF092B8F),
                  ),
                  onPressed: () {
                    _searchController.clear();
                    _searchBooks('');
                  },
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 27,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF087F3E),
            Color(0xFF005C35),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(17),
      ),
      child: const Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Buku baru,\ncerita baru!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 29,
                    height: 1.2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 14),
                Text(
                  'Temukan buku favoritmu\ndengan harga terbaik.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10),
          Icon(
            Icons.auto_stories,
            size: 82,
            color: Color(0xFFB5F1CE),
          ),
        ],
      ),
    );
  }

  Widget _buildActionMenu() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildActionItem(
          icon: Icons.shopping_bag_outlined,
          label: 'Beli',
          color: const Color(0xFF07843F),
          onTap: () {},
        ),
        _buildActionItem(
          icon: Icons.sell_outlined,
          label: 'Jual',
          color: const Color(0xFFFFC323),
          onTap: _openSellPage,
        ),
        _buildActionItem(
          icon: Icons.swap_horiz,
          label: 'Tukar',
          color: const Color(0xFF079FE8),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Fitur tukar buku segera tersedia.'),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: SizedBox(
        width: 90,
        child: Column(
          children: [
            Container(
              width: 82,
              height: 82,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 34,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF092B8F),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle({
    required String title,
    required String action,
    required VoidCallback onTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF092B8F),
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (action.isNotEmpty)
          GestureDetector(
            onTap: onTap,
            child: Text(
              action,
              style: const TextStyle(
                color: Color(0xFF087F3E),
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCategories() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: _categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 14,
        childAspectRatio: 0.78,
      ),
      itemBuilder: (context, index) {
        final category = _categories[index];

        return InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Kategori ${category['name']} dipilih.',
                ),
                duration: const Duration(seconds: 1),
              ),
            );
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  color: category['bg'] as Color,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  category['icon'] as IconData,
                  color: category['fg'] as Color,
                  size: 29,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                category['name'] as String,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF092B8F),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
