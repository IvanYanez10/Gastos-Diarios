import '../models/expense.dart';
import '../repositories/expense_repository.dart';

class ExpensePresenter {
  final ExpenseRepository _repository;
  final View _view;

  ExpensePresenter(this._view, this._repository);

  void fetchExpenses() async {
    try {
      final List<Expense> expenses = await _repository.fetchExpenses();
      _view.displayExpenses(expenses);
    } catch (e) {
      _view.displayError('Error al cargar los gastos');
    }
  }

  void addExpense(Expense expense) async {
    try {
      await _repository.addExpense(expense);
      fetchExpenses(); // Actualizar la lista de gastos después de agregar uno nuevo
    } catch (e) {
      _view.displayError('Error al agregar el gasto');
    }
  }

  void updateExpense(Expense expense) async {
    try {
      await _repository.updateExpense(expense);
      fetchExpenses(); // Actualizar la lista de gastos después de editar uno
    } catch (e) {
      _view.displayError('Error al editar el gasto');
    }
  }

  void deleteExpense(String id) async {
    try {
      await _repository.deleteExpense(id);
      fetchExpenses(); // Actualizar la lista de gastos después de eliminar uno
    } catch (e) {
      _view.displayError('Error al eliminar el gasto');
    }
  }
}

abstract class View {
  void displayExpenses(List<Expense> expenses);
  void displayError(String message);
}
