import 'package:intl/intl.dart';
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

  Future<List<Expense>> getAllExpenses() async {
    final db = await database;
    final List<Map<String, dynamic>> expenseMaps = await db.query(
      'expenses',
      where: 'status NOT IN (?, ?)',
      whereArgs: ['archived', 'deleted'],
      orderBy: 'date DESC',
    );
    return List.generate(expenseMaps.length, (i) {
      return Expense(
        id: expenseMaps[i]['id'],
        description: expenseMaps[i]['description'] as String,
        amount: expenseMaps[i]['amount'] as double,
        date: DateTime.parse(expenseMaps[i]['date'] as String),
        status: expenseMaps[i]['status'] as String,
      );
    });
  }

  static Future<void> updateExpenseStatus(int id, String status) async {
    final db = await database;
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

  Future<List<Expense>> getFilteredExpenses(double maxAmount, String startDate) async {
    final db = await database;
    final List<Map<String, dynamic>> expenseMaps = await db.query(
      'expenses',
      where: 'amount <= ? AND date = ? AND status = ?',
      whereArgs: [maxAmount, startDate, 'created'],
    );
    return List.generate(expenseMaps.length, (i) {
      return Expense(
        id: expenseMaps[i]['id'],
        description: expenseMaps[i]['description'] as String,
        amount: expenseMaps[i]['amount'] as double,
        date: DateTime.parse(expenseMaps[i]['date'] as String),
        status: expenseMaps[i]['status'] as String,
      );
    });
  }

  static Future<void> deleteExpense(int id) async {
    final db = await database;
    await db.delete(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<double?> getHighestAmount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT MAX(amount) as highest_amount FROM expenses');
    final highestAmount = result.isNotEmpty ? result.first['highest_amount'] as double : null;
    return highestAmount;
  }

  static Future<void> clearDatabase() async {
    final db = await database;
    await db.delete('expenses');
  }

}
