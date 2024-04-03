import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/expense.dart';

class DatabaseHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  static Future<Database> initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'expenses.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE expenses(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT,
            amount REAL,
            description TEXT,
            status TEXT
          )
        ''');
      },
    );
  }

  Future<List<Expense>> getFilteredExpenses(double minAmount, double maxAmount, DateTime startDate, DateTime endDate) async {
    final db = await database;
    final result = await db.query(
      'expenses',
      where: 'amount BETWEEN ? AND ? AND date BETWEEN ? AND ?',
      whereArgs: [minAmount, maxAmount, startDate.millisecondsSinceEpoch, endDate.millisecondsSinceEpoch],
    );
    return result.map((json) => Expense.fromJson(json)).toList();
  }

  static Future<void> updateExpenseStatus(int id, String status) async {
    // Get a reference to the database
    final db = await database;

    // Update the status of the expense record with the given id
    await db.update(
      'expenses',
      {'status': status},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> updateExpense(Expense expense) async {
    final db = await database;
    await db.update(
      'expenses',
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

}
