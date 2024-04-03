import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/expense.dart';
import '../utils/database_helper.dart';
import '../widgets/date_picker.dart';

class EditExpenseView extends StatefulWidget {
  final Expense expense;

  const EditExpenseView({Key? key, required this.expense}) : super(key: key);

  @override
  _EditExpenseViewState createState() => _EditExpenseViewState();
}

class _EditExpenseViewState extends State<EditExpenseView> {
  late TextEditingController _descriptionController;
  late TextEditingController _amountController;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(text: widget.expense.description);
    _amountController = TextEditingController(text: widget.expense.amount.toString());
    _selectedDate = widget.expense.date;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Gasto'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              await DatabaseHelper.deleteExpense(widget.expense.id);
              Navigator.pop(context);
            },
          )
        ],
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
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')), // Allow numbers and dot
              ],
            ),
            const SizedBox(height: 16.0),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey), // Border color
                borderRadius: BorderRadius.circular(8), // Rounded corners
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16), // Padding
              child: DateSelectorButton(
                selectedDate: _selectedDate,
                onChanged: (newDate) {
                  setState(() {
                    _selectedDate = newDate!;
                  });
                },
              )

            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                final updatedExpense = Expense(
                  id: widget.expense.id,
                  description: _descriptionController.text,
                  amount: double.parse(_amountController.text),
                  date: _selectedDate,
                  status: widget.expense.status,
                );
                await DatabaseHelper.updateExpense(updatedExpense);
                Navigator.pop(context);
              },
              child: const Text('Guardar Cambios'),
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
