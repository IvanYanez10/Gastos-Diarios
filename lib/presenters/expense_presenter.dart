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

  Future<double?> getHighestAmount() async {
    try {
      final highestAmount = await _databaseHelper.getHighestAmount();
      return highestAmount;
    } catch (e) {
      print('Error fetching highest amount: $e');
      return null;
    }
  }

  Future<void> clearDatabase() async {
    try {
      await DatabaseHelper.clearDatabase();
    } catch (e) {
      // Handle any errors
      print('Error clearing database: $e');
    }
  }

  Future<List<Expense>> fetchFilteredExpenses(double maxAmount, String startDate) async {
    try {
      final expenses = await _databaseHelper.getFilteredExpenses(
        maxAmount,
        startDate,
      );
      return expenses;
    } catch (e) {
      print('Error fetching filtered expenses: $e');
      return [];
    }
  }

}
