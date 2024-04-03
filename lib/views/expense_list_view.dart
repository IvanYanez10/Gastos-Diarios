import 'package:flutter/material.dart';
import 'package:gastos_diarios/views/add_expense_view.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';
import '../presenters/expense_presenter.dart'; // Import the ExpensePresenter
import 'edit_expense_view.dart';

class ExpenseListView extends StatefulWidget {
  const ExpenseListView({Key? key}) : super(key: key);

  @override
  _ExpenseListViewState createState() => _ExpenseListViewState();
}

class _ExpenseListViewState extends State<ExpenseListView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ExpensePresenter _presenter = ExpensePresenter();

  List<Expense> _expenses = [];
  List<Expense> _filteredExpenses = [];

  // Define filters
  double _minAmount = 0;
  double _maxAmount = 2000;
  double _currentSliderValue = 50;
  DateTime _startDate = DateTime.now().subtract(Duration(days: 7));
  DateTime _endDate = DateTime.now();

  late DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadExpenses();
    _selectedDate = DateTime.now();
  }

  Future<void> _loadExpenses() async {
    final expenses = await _presenter.fetchAllExpenses();
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
            onPressed: _openEndDrawer,
            icon: const Icon(Icons.filter_list),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _expenses.length,
        itemBuilder: (context, index) {
          final expense = _expenses[index];
          return GestureDetector(
            onTap: () => Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (c, a1, a2) => EditExpenseView(expense: expense),
                  transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                  transitionDuration: const Duration(milliseconds: 100),
                  reverseTransitionDuration: const Duration(milliseconds: 100),
                ),
              ).then((value) => _loadExpenses()),
            child: ListTile(
              leading: Text(DateFormat('dd/MM/yy').format(expense.date)),
              title: Text(expense.description),
              subtitle: Text('\$${expense.amount}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  // Update expense status to 'deleted'
                  await _presenter.updateExpenseStatus(expense.id, 'deleted');
                  // Reload expenses after deletion
                  await _loadExpenses();
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (c, a1, a2) => const AddExpenseView(),
              transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
              transitionDuration: const Duration(milliseconds: 100),
              reverseTransitionDuration: const Duration(milliseconds: 100),
            ),
          ).then((value) => _loadExpenses()),
        child: const Icon(Icons.add),
      ),
      endDrawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              const ListTile(
                title: Text('Filtrar'),
                // Add filter options here
              ),
              const Text('Monto'),
              Slider(
                value: _currentSliderValue,
                min: 0,
                max: _maxAmount,
                divisions: 100,
                label: _currentSliderValue.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    _currentSliderValue = value;
                  });
                },
              ),
              TextButton(
                onPressed: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2015, 8),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null && pickedDate != _selectedDate) {
                    setState(() {
                      _selectedDate = pickedDate;
                    });
                  }
                },
                child: Text('Fecha: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
              ),
              ListTile(
                title: TextButton(
                  onPressed: _closeEndDrawer, // Use _closeEndDrawer directly
                  child: const Text('Apply'),
                ),
              ),
            ],
          ),
        ),
      ),
      endDrawerEnableOpenDragGesture: false,
    );
  }


}

