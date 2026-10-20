import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

import '../../controllers/transaction_controller.dart';
import '../../controllers/payment_controller.dart';

class CheckoutScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final double totalPrice;

  const CheckoutScreen({
    super.key,
    required this.cartItems,
    required this.totalPrice,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _supabase = Supabase.instance.client;
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();

  final TransactionController _transactionController = TransactionController();

  final PaymentController _paymentController = PaymentController();

  String _selectedPayment = 'transfer';
  bool _isProcessing = false;
  int _currentStep = 0;

  final List<Map<String, Object>> _paymentMethods = [
    {
      'id': 'transfer',
      'name': 'Transfer Bank',
      'icon': Icons.account_balance,
      'databaseValue': 'Transfer_Bank',
    },
    {
      'id': 'ewallet',
      'name': 'E-Wallet (OVO, DANA, GoPay)',
      'icon': Icons.account_balance_wallet,
      'databaseValue': 'E-Wallet',
    },
    {
      'id': 'cod',
      'name': 'COD (Bayar di Tempat)',
      'icon': Icons.money,
      'databaseValue': 'COD',
    },
  ];

  @override
  void dispose() {
    _addressController.dispose();
    _transactionController.dispose();
    _paymentController.dispose();
    super.dispose();
  }

  // ==================== PAYMENT METHOD ====================

  String get _databasePaymentMethod {
    final method = _paymentMethods.firstWhere(
      (item) => item['id'] == _selectedPayment,
    );

    return method['databaseValue'] as String;
  }

  // ==================== CART ITEM HELPERS ====================

  Map<String, dynamic> _getBook(Map<String, dynamic> item) {
    final dynamic nestedBook = item['books'] ?? item['buku'] ?? item['book'];

    if (nestedBook is Map) {
      return Map<String, dynamic>.from(nestedBook);
    }

    return item;
  }

  int _getQuantity(Map<String, dynamic> item) {
    final value = item['quantity'] ?? item['jumlah'] ?? 1;

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(value.toString()) ?? 1;
  }

  num _getBookPrice(Map<String, dynamic> book) {
    final value = book['price'] ?? book['harga'] ?? 0;

    if (value is num) {
      return value;
    }

    return num.tryParse(value.toString()) ?? 0;
  }

  String _getBookTitle(Map<String, dynamic> book) {
    return (book['title'] ?? book['judul_buku'] ?? book['judul'] ?? 'Buku')
        .toString();
  }

  // ==================== PROCESS CHECKOUT ====================

  Future<void> _processOrder() async {
    if (_isProcessing) return;

    if (!_formKey.currentState!.validate()) return;

    if (_supabase.auth.currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan login terlebih dahulu.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      // 1. Proses checkout melalui RPC.
      // Transaksi, detail transaksi, pembayaran, dan pengosongan
      // keranjang ditangani oleh database dalam satu proses atomik.
      final result = await _transactionController.checkoutBookcycle(
        alamatPengiriman: _addressController.text.trim(),
        metodePembayaran: _databasePaymentMethod,
      );

      if (result == null) {
        throw Exception(
          _transactionController.errorMessage ??
              'Checkout gagal. Silakan coba kembali.',
        );
      }

      // 2. Ambil ID transaksi dari hasil RPC.
      final rawTransactionId = result['transaksi_id'];

      if (rawTransactionId is! num) {
        throw Exception('ID transaksi tidak ditemukan pada hasil checkout.');
      }

      final int transaksiId = rawTransactionId.toInt();

      // 3. Ambil data pembayaran yang dibuat oleh RPC.
      // Kegagalan mengambil data pembayaran tidak membatalkan
      // transaksi yang sudah berhasil disimpan.
      await _paymentController.fetchPayment(transaksiId);

      if (!mounted) return;

      // 4. Gunakan total resmi dari database.
      final rawTotal = result['total_harga'];

      final double checkoutTotal = rawTotal is num
          ? rawTotal.toDouble()
          : widget.totalPrice;

      setState(() {
        _currentStep = 2;
      });

      // 5. Tampilkan konfirmasi keberhasilan.
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color(0xFF2E7D32),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 40),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Pesanan Berhasil!',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Total: Rp${NumberFormat('#,##0', 'id_ID').format(checkoutTotal)}',
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Text(
                  'Nomor transaksi: $transaksiId',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  // Tutup dialog.
                  Navigator.of(dialogContext).pop();

                  // Kembali dari checkout.
                  Navigator.of(context).pop();

                  // Kembali dari keranjang.
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Selesai',
                  style: TextStyle(
                    color: Color(0xFF2E7D32),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memproses pesanan: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  // ==================== BUILD UI ====================

  @override
  Widget build(BuildContext context) {
    const Color primaryGreen = Color(0xFF2E7D32);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: _isProcessing ? null : () => Navigator.pop(context),
        ),
        title: const Text(
          'Checkout',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: _isProcessing
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Stepper
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildStepIndicator(1, 'Alamat'),
                        const Expanded(child: Divider()),
                        _buildStepIndicator(2, 'Pembayaran'),
                        const Expanded(child: Divider()),
                        _buildStepIndicator(3, 'Selesai'),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Alamat Pengiriman
                    const Text(
                      'Alamat Pengiriman',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    TextFormField(
                      controller: _addressController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Masukkan alamat lengkap pengiriman',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: primaryGreen,
                            width: 2,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Alamat wajib diisi';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    // Metode Pembayaran
                    const Text(
                      'Metode Pembayaran',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    ..._paymentMethods.map((method) {
                      final methodId = method['id'] as String;
                      final methodName = method['name'] as String;
                      final methodIcon = method['icon'] as IconData;

                      final isSelected = _selectedPayment == methodId;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? primaryGreen
                                : Colors.grey[300]!,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: RadioListTile<String>(
                          value: methodId,
                          groupValue: _selectedPayment,
                          onChanged: (value) {
                            if (value == null) return;

                            setState(() {
                              _selectedPayment = value;
                            });
                          },
                          activeColor: primaryGreen,
                          title: Text(methodName),
                          secondary: Icon(methodIcon, color: primaryGreen),
                        ),
                      );
                    }),

                    const SizedBox(height: 24),

                    // Ringkasan Pesanan
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Ringkasan Pesanan',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const Divider(),

                          ...widget.cartItems.map((item) {
                            final book = _getBook(item);
                            final qty = _getQuantity(item);

                            final price = _getBookPrice(book) * qty;

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${_getBookTitle(book)} x$qty',
                                      style: const TextStyle(fontSize: 12),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    'Rp${NumberFormat('#,##0', 'id_ID').format(price)}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),

                          const Divider(),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Rp${NumberFormat('#,##0', 'id_ID').format(widget.totalPrice)}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: primaryGreen,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Tombol Bayar
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _processOrder,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryGreen,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: const Text('Bayar Sekarang'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  // ==================== STEP INDICATOR ====================

  Widget _buildStepIndicator(int step, String label) {
    final isActive = _currentStep >= step - 1;

    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF2E7D32) : Colors.grey[300],
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$step',
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        const SizedBox(height: 4),

        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isActive ? const Color(0xFF2E7D32) : Colors.grey,
          ),
        ),
      ],
    );
  }
}
