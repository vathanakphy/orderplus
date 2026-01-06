import 'package:sqflite/sqflite.dart';

class AppDatabase {
  final String dbPath;

  AppDatabase({required this.dbPath});

  Future<Database> open() async {
    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE categories(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            isActive INTEGER
          )
        ''');
        await db.execute('''
          CREATE TABLE products(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            description TEXT,
            price REAL,
            imageUrl TEXT,
            categoryId INTEGER NOT NULL,
            isAvailable INTEGER,
            FOREIGN KEY (categoryId) REFERENCES categories(id)
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
