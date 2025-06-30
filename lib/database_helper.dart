import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'restaurant.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT UNIQUE,
            password TEXT,
            name TEXT,
            email TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE menu_items (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            price REAL,
            description TEXT,
            image_url TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE orders (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER,
            table_number TEXT,
            items TEXT,
            status TEXT,
            FOREIGN KEY(user_id) REFERENCES users(id)
          )
        ''');
        await db.insert('menu_items', {
          'name': 'Nasi Goreng',
          'price': 15000.0,
          'description': 'Nasi goreng spesial dengan telur dan ayam',
          'image_url': 'assets/images/nasi_goreng.jpg'
        });
        await db.insert('menu_items', {
          'name': 'Es Teh',
          'price': 5000.0,
          'description': 'Es teh manis segar',
          'image_url': 'assets/images/es_teh.jpg'
        });
        await db.insert('menu_items', {
          'name': 'Mie Goreng',
          'price': 14000.0,
          'description': 'Mie goreng lezat dengan sayuran dan ayam',
          'image_url': 'assets/images/mie_goreng.jpg'
        });
        await db.insert('menu_items', {
          'name': 'Ayam Bakar',
          'price': 20000.0,
          'description': 'Ayam bakar bumbu khas dengan sambal dan lalapan',
          'image_url': 'assets/images/ayam_bakar.jpg'
        });
        await db.insert('menu_items', {
          'name': 'Jus Jeruk',
          'price': 8000.0,
          'description': 'Jus jeruk segar alami',
          'image_url': 'assets/images/jus_jeruk.jpg'
        });
        await db.insert('menu_items', {
          'name': 'Sate Ayam',
          'price': 18000.0,
          'description': 'Sate ayam dengan bumbu kacang dan lontong',
          'image_url': 'assets/images/sate_ayam.jpeg'
        });
        await db.insert('menu_items', {
          'name': 'Soto Ayam',
          'price': 16000.0,
          'description': 'Soto ayam hangat dengan koya dan telur',
          'image_url': 'assets/images/soto_ayam.jpeg'
        });
        //
      },
    );
  }
}