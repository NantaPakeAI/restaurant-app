import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'database_helper.dart';
import 'order_status_screen.dart';
import 'dart:convert';

class OrderConfirmationScreen extends StatefulWidget {
  @override
  _OrderConfirmationScreenState createState() => _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  final _tableNumberController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<void> _confirmOrder() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId');
    String? cartString = prefs.getString('cart');
    List cart = cartString != null ? jsonDecode(cartString) : [];
    String menuList = '';
    for (var item in cart) {
      menuList += '${item['name']} x${item['qty'] ?? 1}\n';
    }
    if (cart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Keranjang kosong!')),
      );
      return;
    }
    if (_tableNumberController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nomor meja harus diisi!')),
      );
      return;
    }

    // Tampilkan dialog konfirmasi
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Konfirmasi Pesanan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nomor Meja: ${_tableNumberController.text}'),
            SizedBox(height: 8),
            Text('Menu Dipesan:'),
            Text(menuList, style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Pesan'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    if (userId != null) {
      try {
        final db = await _dbHelper.database;
        int orderId = await db.insert('orders', {
          'user_id': userId,
          'table_number': _tableNumberController.text,
          'items': menuList.trim(),
          'status': 'Pending',
        });
        print('Order ID: $orderId'); // Untuk debug
        await prefs.remove('cart');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Pesanan berhasil dikonfirmasi')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OrderStatusScreen(
              orderId: orderId,
              tableNumber: _tableNumberController.text,
              status: 'Pending',
            ),
          ),
        );
      } catch (e) {
        print('Error saat insert pesanan: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal membuat pesanan!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Konfirmasi Pesanan'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: _tableNumberController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                hintText: 'Nomor Meja',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _confirmOrder,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text('Konfirmasi Pesanan', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}