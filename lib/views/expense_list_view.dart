import 'package:flutter/material.dart';
import 'package:gastos_diarios/views/add_expense_view.dart';
import '../models/expense.dart';
import '../presenters/expense_presenter.dart';
import '../widgets/Expense_Item.dart';
import '../widgets/date_picker.dart';
import 'edit_expense_view.dart';

class ExpenseListView extends StatefulWidget {
  const ExpenseListView({Key? key}) : super(key: key);

  @override
  _ExpenseListViewState createState() => _ExpenseListViewState();
}

class _ExpenseListViewState extends State<ExpenseListView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ExpensePresenter _presenter = ExpensePresenter();

  bool _filtering = false;
  List<Expense> _expenses = [];

  final double _minAmount = 0;
  double _currentSliderValue=0;

  double _highestAmount = 2000;
  DateTime _selectedDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  Future<void> _loadHighestAmount() async {
    final highestAmount = await _presenter.getHighestAmount();
    setState(() {
      _highestAmount = highestAmount! + 200;
    });
  }

  Future<void> _loadExpenses() async {
    final expenses = await _presenter.fetchAllExpenses();
    setState(() {
      _expenses = expenses;
    });
    if(_expenses.isNotEmpty){
      _loadHighestAmount();
    }
  }

  Future<void> _clearDatabase() async {
    await _presenter.clearDatabase();
    _loadExpenses();
  }

  Future<void> _fetchFilteredExpenses() async {
    final expenses = await _presenter.fetchFilteredExpenses(_currentSliderValue, _selectedDate.toString());
    _closeEndDrawer();
    setState(() {
      _expenses = expenses;
      _filtering=true;
    });
  }

  void _cancelFiltering() {
    _loadExpenses();
    setState(() {
      _filtering=false;
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
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        title: !_filtering ? Text('Lista de Gastos', style: Theme.of(context).textTheme.headlineSmall)
        :Text('Filtrado', style: Theme.of(context).textTheme.headlineSmall),
        actions: [
          Visibility(
            visible: _expenses.isNotEmpty || _filtering,
            child: Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: _filtering ? IconButton(
                onPressed: _cancelFiltering,
                icon: const Icon(Icons.filter_alt_off, color: Colors.red,),
              )
                  : IconButton(
                onPressed: _openEndDrawer,
                icon: const Icon(Icons.filter_list),
              )
            ),
          ),
        ],
      ),
      body: _expenses.isNotEmpty ? Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
        child: ListView.builder(
          physics: _expenses.isNotEmpty ? const AlwaysScrollableScrollPhysics() : const NeverScrollableScrollPhysics(),
          shrinkWrap: true, // Ensure that the ListView occupies only the necessary space
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
              child: ExpenseItem(expense: expense),
            );
          },
        ),
      ) : Center(child: Text('Sin registros', style: Theme.of(context).textTheme.caption,),),
      floatingActionButton: Visibility(
        visible: !_filtering,
        child: FloatingActionButton(
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
      ),
      endDrawer: Drawer(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Filtrar', style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 10),
                    const Text('Monto'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Slider(
                          value: _currentSliderValue,
                          min: _minAmount,
                          max: _highestAmount,
                          divisions: 100,
                          label: '\$${_currentSliderValue > 1000
                              ? '${(_currentSliderValue / 1000).toStringAsFixed(1)}k'
                              : '${_currentSliderValue.round()}'}',
                          onChanged: (double value) {
                            setState(() {
                              _currentSliderValue = value;
                            });
                          },
                        ),
                        Text('\$${_currentSliderValue > 1000
                            ? '${(_currentSliderValue / 1000).toStringAsFixed(1)}k'
                            : '${_currentSliderValue.round()}'}'),
                      ],
                    ),
                    DateSelectorButton(
                      selectedDate: _selectedDate,
                      onChanged: (newDate) {
                        setState(() {
                          _selectedDate = newDate!;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => _fetchFilteredExpenses(),
                      child: const Text('Aplicar filtro'),
                    ),
                  ],
                ),
                _expenses.isNotEmpty ? Column(
                  children: [
                    const Divider(),
                    // Add the Clean Database button
                    TextButton(
                      onPressed: () {
                        _clearDatabase();
                        _closeEndDrawer();
                        },
                      child: const Text('Reiniciar base de datos', style: TextStyle(color: Colors.red, fontSize: 14),),
                    ),
                  ],
                )
                : const Center(child: Text('Demo Gastos Diarios', style: TextStyle(color: Colors.grey)))
              ],
            ),
          ),
        ),
      ),
      endDrawerEnableOpenDragGesture: false,
    );
  }


}

