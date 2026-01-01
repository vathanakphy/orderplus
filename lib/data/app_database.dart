import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  final String dbPath;

  AppDatabase({required this.dbPath});

  Future<Database> open() async {
    final path = join(await getDatabasesPath(), dbPath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE products(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            description TEXT,
            price REAL,
            imageUrl TEXT,
            category TEXT,
            isAvailable INTEGER
          )
        ''');

        await db.execute('''
          CREATE TABLE orders(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            tableNumber INTEGER,
            status TEXT,
            paymentStatus TEXT,
            createdAt TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE order_items(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            orderId INTEGER,
            productId INTEGER,
            quantity INTEGER,
            priceAtOrder REAL,
            note TEXT,
            FOREIGN KEY(orderId) REFERENCES orders(id),
            FOREIGN KEY(productId) REFERENCES products(id)
          )
        ''');
      },
    );
  }
}
