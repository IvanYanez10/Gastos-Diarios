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

  static Future<List<Expense>> getFilteredExpenses({
    double? minAmount,
    double? maxAmount,
    DateTime? startDate,
  }) async {
    final db = await database;
    late List<Map<String, dynamic>> expenseMaps;

    if (minAmount != null || maxAmount != null) {
      // Filter by amount
      expenseMaps = await _filterByAmount(db, minAmount, maxAmount);
    } else if (startDate != null) {
      // Filter by date
      expenseMaps = await _filterByDate(db, startDate);
    } else {
      // No filtering
      expenseMaps = await db.query('expenses', where: 'status = ?', whereArgs: ['created']);
    }

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

  static Future<List<Map<String, dynamic>>> _filterByAmount(Database db, double? minAmount, double? maxAmount) async {
    if (minAmount != null && maxAmount != null) {
      // Filter by min and max amount
      return await db.query(
        'expenses',
        where: 'amount >= ? AND amount <= ? AND status = ?',
        whereArgs: [minAmount, maxAmount, 'created'],
      );
    } else if (minAmount != null) {
      // Filter by min amount
      return await db.query(
        'expenses',
        where: 'amount >= ? AND status = ?',
        whereArgs: [minAmount, 'created'],
      );
    } else {
      // Filter by max amount
      return await db.query(
        'expenses',
        where: 'amount <= ? AND status = ?',
        whereArgs: [maxAmount, 'created'],
      );
    }
  }

  static Future<List<Map<String, dynamic>>> _filterByDate(Database db, DateTime? startDate) async {
    if (startDate != null) {
      // Filter by start date
      return await db.query(
        'expenses',
        where: 'date = ? AND status = ?',
        whereArgs: [DateFormat('yyyy-MM-dd').format(startDate), 'created'],
      );
    } else {
      // If no start date is provided, return all expenses
      return await db.query('expenses', where: 'status = ?', whereArgs: ['created']);
    }
  }
}
