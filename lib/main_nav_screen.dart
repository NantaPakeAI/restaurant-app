// main_nav_screen.dart
import 'package:flutter/material.dart';
import 'menu_screen.dart';
import 'order_status_screen.dart';
import 'order_history_screen.dart';

class MainNavScreen extends StatefulWidget {
  @override
  _MainNavScreenState createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    MenuScreen(),
    // CartScreen(), // Hapus tombol keranjang dari bottom navbar
    OrderStatusScreen(
      orderId: 0, // Atur sesuai kebutuhan
      tableNumber: '',
      status: 'Pending',
    ),
    OrderHistoryScreen(),
  ];

  void _onNavBarTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavBarTapped,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Menu',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.shopping_cart),
          //   label: 'Keranjang',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Status',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Riwayat',
          ),
        ],
      ),
    );
  }
}