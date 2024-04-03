import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/expense.dart';
import '../utils/database_helper.dart';
import '../widgets/date_picker.dart';

class AddExpenseView extends StatefulWidget {
  final Expense? expense;

  const AddExpenseView({Key? key, this.expense}) : super(key: key);

  @override
  _AddExpenseViewState createState() => _AddExpenseViewState();
}

class _AddExpenseViewState extends State<AddExpenseView> {
  late TextEditingController _descriptionController;
  late TextEditingController _amountController;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(text: widget.expense?.description ?? '');
    _amountController = TextEditingController(text: widget.expense?.amount.toString() ?? '');
    _selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuevo Gasto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Descripción'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: 'Monto', prefixText: '\$'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true), // Set keyboardType to allow decimal input
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')), // Allow digits and optional decimal point
              ],
            ),
            const SizedBox(height: 16.0),
            DateSelectorButton(
              selectedDate: _selectedDate,
              onChanged: (newDate) {
                setState(() {
                  _selectedDate = newDate!;
                });
              },
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                String _selectedDateHandler = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day).toString();
                final newExpense = {
                  'description': _descriptionController.text,
                  'amount': double.parse(_amountController.text),
                  'date': _selectedDateHandler,
                  'status': 'created',
                };
                await DatabaseHelper.database.then((db) {
                  db.insert('expenses', newExpense);
                });
                Navigator.pop(context);
              },
              child: const Text('Agregar Gasto'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }
}
