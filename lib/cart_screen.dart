import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Map<String, dynamic>> _cartItems = [];

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cartString = prefs.getString('cart');
    if (cartString != null) {
      List cart = jsonDecode(cartString);
      setState(() {
        _cartItems = List<Map<String, dynamic>>.from(cart);
      });
    } else {
      setState(() {
        _cartItems = [];
      });
    }
  }

  Future<void> _removeCartItem(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _cartItems.removeAt(index);
    await prefs.setString('cart', jsonEncode(_cartItems));
    setState(() {});
  }

  Future<void> _updateCartItemQuantity(int index, int newQty) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (newQty <= 0) {
      _cartItems.removeAt(index);
    } else {
      _cartItems[index]['qty'] = newQty;
    }
    await prefs.setString('cart', jsonEncode(_cartItems));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double total = 0;
    for (var item in _cartItems) {
      total += (item['price'] ?? 0) * (item['qty'] ?? 1);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Keranjang'),
        backgroundColor: Colors.orange,
      ),
      body: _cartItems.isEmpty
          ? Center(child: Text('Keranjang Anda kosong'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: _cartItems.length,
                    itemBuilder: (context, index) {
                      final item = _cartItems[index];
                      final qty = item['qty'] ?? 1;
                      return Dismissible(
                        key: Key(item['name']),
                        onDismissed: (direction) {
                          _removeCartItem(index);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Item dihapus dari keranjang')),
                          );
                        },
                        background: Container(color: Colors.red),
                        child: Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            title: Text(item['name']),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Rp ${item['price'].toStringAsFixed(0)}'),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.remove),
                                      onPressed: () {
                                        _updateCartItemQuantity(index, qty - 1);
                                      },
                                    ),
                                    Text('$qty'),
                                    IconButton(
                                      icon: Icon(Icons.add),
                                      onPressed: () {
                                        _updateCartItemQuantity(index, qty + 1);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _removeCartItem(index);
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('Rp ${total.toStringAsFixed(0)}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
      floatingActionButton: _cartItems.isEmpty
          ? null
          : FloatingActionButton(
              onPressed: () => Navigator.pushNamed(context, '/order_confirmation'),
              backgroundColor: Colors.orange,
              child: Icon(Icons.check),
            ),
    );
  }
}