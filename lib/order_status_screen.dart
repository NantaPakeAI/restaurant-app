import 'package:flutter/material.dart';
import './database_helper.dart';

class OrderStatusScreen extends StatelessWidget {
  final int orderId;
  final String tableNumber;
  final String status;

  OrderStatusScreen({
    required this.orderId,
    required this.tableNumber,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Status Pesanan'),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Card(
          margin: EdgeInsets.all(32),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.hourglass_top, color: Colors.orange, size: 64),
                SizedBox(height: 16),
                Text('Nomor Meja: $tableNumber', style: TextStyle(fontSize: 20)),
                SizedBox(height: 8),
                Text('Status: $status', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 24),
                Text('Pesanan Anda sedang diproses. Mohon tunggu...', textAlign: TextAlign.center),
                SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          final dbHelper = DatabaseHelper();
                          final db = await dbHelper.database;
                          await db.delete(
                            'orders',
                            where: 'id = ?',
                            whereArgs: [orderId],
                          );
                          Navigator.popUntil(context, (route) => route.isFirst);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Pesanan dibatalkan')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text('Batalkan Pesanan'),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          final dbHelper = DatabaseHelper();
                          final db = await dbHelper.database;
                          await db.update(
                            'orders',
                            {'status': 'Selesai'},
                            where: 'id = ?',
                            whereArgs: [orderId],
                          );
                          Navigator.pushReplacementNamed(context, '/order_history');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text('Pesanan Diterima'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}