import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import 'item_detail_screen.dart';
import 'cart_screen.dart';
import 'order_confirmation_screen.dart';
import 'order_status_screen.dart';
import 'order_history_screen.dart';
import 'main_nav_screen.dart';

void main() {
  runApp(RestaurantApp());
}

class RestaurantApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: TextTheme(
          titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(fontSize: 16),
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/menu': (context) => MainNavScreen(),
        '/item_detail': (context) => ItemDetailScreen(),
        '/cart': (context) => CartScreen(),
        '/order_confirmation': (context) => OrderConfirmationScreen(),
        '/order_status': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return OrderStatusScreen(
            tableNumber: args['tableNumber'] ?? '',
            status: args['status'] ?? '',
            orderId: args['orderId'] is int
                ? args['orderId']
                : int.tryParse(args['orderId']?.toString() ?? '0') ?? 0,
          );
        },
        '/order_history': (context) => OrderHistoryScreen(),
      },
    );
  }
}