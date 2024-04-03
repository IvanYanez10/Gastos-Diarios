import '../models/expense.dart';
import '../utils/database_helper.dart';

class ExpensePresenter {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<List<Expense>> fetchAllExpenses() async {
    try {
      final expenses = await _databaseHelper.getAllExpenses();
      return expenses;
    } catch (e) {
      print('Error fetching expenses: $e');
      return [];
    }
  }

  Future<void> updateExpenseStatus(int id, String status) async {
    try {
      await DatabaseHelper.updateExpenseStatus(id, status);
    } catch (e) {
      print('Error updating expense status: $e');
    }
  }
}
