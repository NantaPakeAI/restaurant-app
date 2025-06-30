import 'package:flutter/material.dart';
import 'database_helper.dart';

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _menuItems = [];

  @override
  void initState() {
    super.initState();
    _loadMenuItems();
  }

  Future<void> _loadMenuItems() async {
    final db = await _dbHelper.database;
    final items = await db.query('menu_items');
    setState(() {
      _menuItems = items;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu Restoran'),
        backgroundColor: Colors.orange,
        actions: [], // <-- hanya ini, tidak ada tombol lain
      ),
      body: _menuItems.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: _menuItems.length,
              itemBuilder: (context, index) {
                final item = _menuItems[index];
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(item['image_url'], width: 60, height: 60, fit: BoxFit.cover),
                    ),
                    title: Text(item['name']),
                    subtitle: Text('Rp ${item['price'].toStringAsFixed(0)}'),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => Navigator.pushNamed(context, '/item_detail', arguments: item),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/cart'),
        backgroundColor: Colors.orange,
        child: Icon(Icons.shopping_cart),
      ),
    );
  }
}