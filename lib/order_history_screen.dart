import 'package:flutter/material.dart';
import 'database_helper.dart';

class OrderHistoryScreen extends StatefulWidget {
  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _orders = [];

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    final db = await _dbHelper.database;
    final orders = await db.query('orders', where: 'status = ?', whereArgs: ['Selesai']);
    setState(() {
      _orders = orders;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Riwayat Pesanan'), backgroundColor: Colors.orange),
      body: _orders.isEmpty
          ? Center(child: Text('Belum ada riwayat pesanan.'))
          : ListView.builder(
              itemCount: _orders.length,
              itemBuilder: (context, index) {
                final order = _orders[index];
                return ListTile(
                  title: Text('Meja: ${order['table_number']}'),
                  subtitle: Text('Menu: ${order['items']}'),
                  trailing: Text(order['status']),
                );
              },
            ),
    );
  }
}