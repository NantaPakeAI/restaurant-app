import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ItemDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final item = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return Scaffold(
      appBar: AppBar(
        title: Text(item['name']),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(item['image_url'], height: 250, width: double.infinity, fit: BoxFit.cover),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['name'], style: Theme.of(context).textTheme.titleLarge),
                SizedBox(height: 8),
                Text('Rp ${item['price'].toStringAsFixed(0)}', style: TextStyle(fontSize: 18, color: Colors.orange)),
                SizedBox(height: 16),
                Text(item['description'], style: TextStyle(fontSize: 16)),
                SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      String? cartString = prefs.getString('cart');
                      List cart = cartString != null ? jsonDecode(cartString) : [];
                      bool found = false;
                      for (var itemCart in cart) {
                        if (itemCart['name'] == item['name']) {
                          itemCart['qty'] = (itemCart['qty'] ?? 1) + 1;
                          found = true;
                          break;
                        }
                      }
                      if (!found) {
                        cart.add({
                          'name': item['name'],
                          'price': item['price'],
                          'image_url': item['image_url'],
                          'qty': 1,
                        });
                      }
                      await prefs.setString('cart', jsonEncode(cart));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${item['name']} ditambahkan ke keranjang')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text('Tambah ke Keranjang', style: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}