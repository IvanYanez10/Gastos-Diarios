import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../models/expense.dart';
import '../utils/database_helper.dart';
import 'edit_expense_view.dart';
import 'package:intl/intl.dart';

class ExpenseListView extends StatefulWidget {
  const ExpenseListView({Key? key}) : super(key: key);

  @override
  _ExpenseListViewState createState() => _ExpenseListViewState();
}

class _ExpenseListViewState extends State<ExpenseListView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late Database _database;
  List<Expense> _filteredExpenses = [];
  List<Expense> _expenses = [];

  double _minAmount = 0;
  double _maxAmount = 100;
  DateTime _startDate = DateTime.now().subtract(Duration(days: 7));
  DateTime _endDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    initDatabase();
  }

  Future<void> initDatabase() async {
    _database = await DatabaseHelper.database;
    reloadExpenses();
  }

  Future<void> _loadFilteredExpenses() async {
    final filteredExpenses = await DatabaseHelper().getFilteredExpenses(_minAmount, _maxAmount, _startDate, _endDate);
    setState(() {
      _filteredExpenses = filteredExpenses;
    });
  }

  Future<void> reloadExpenses() async {
    final List<Map<String, dynamic>> expenseMaps = await _database.query('expenses', where: 'status NOT IN (?, ?)', whereArgs: ['archived', 'deleted']);
    final List<Expense> expenses = List.generate(expenseMaps.length, (i) {
      return Expense(
        id: expenseMaps[i]['id'],
        description: expenseMaps[i]['description'] as String,
        amount: expenseMaps[i]['amount'] as double,
        date: DateTime.parse(expenseMaps[i]['date'] as String),
        status: expenseMaps[i]['status'] as String,
      );
    });
    setState(() {
      _expenses = expenses;
    });
  }

  void _openEndDrawer() {
    _scaffoldKey.currentState!.openEndDrawer();
  }

  void _closeEndDrawer() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Lista de Gastos'),
        actions: [
          IconButton(
            onPressed: () {
              _openEndDrawer;
            },
            icon: const Icon(Icons.filter_list),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _expenses.length,
        itemBuilder: (context, index) {
          final expense = _expenses[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditExpenseView(expense: expense),
                ),
              );
            },
            child: ListTile(
              leading: Text(DateFormat('dd/MM/yy').format(expense.date)),
              title: Text(expense.description),
              subtitle: Text('\$${expense.amount}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  await DatabaseHelper.updateExpenseStatus(expense.id, 'deleted');
                  setState(() {
                    _expenses.remove(expense);
                  });
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add_expense');
        },
        child: const Icon(Icons.add),
      ),
      endDrawer: Drawer(
        child: Column(
          children: [
            const ListTile(
              title: Text('Filter Options'),
              // Add filter options here
            ),
            const ListTile(
              title: Text('Amount Slider'),
              // Add amount slider here
            ),
            const ListTile(
              title: Text('Date Selector'),
              // Add date selector here
            ),
            ListTile(
              title: TextButton(
                onPressed: () {
                  _closeEndDrawer;
                },
                child: const Text('Apply'),
              ),
            ),
          ],
        ),
      ),
      endDrawerEnableOpenDragGesture: false,
    );
  }
}
