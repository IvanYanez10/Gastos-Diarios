import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/expense.dart';

class ExpenseRepository {
  Future<List<Expense>> fetchExpenses() async {
    // Simulamos la obtención de datos de una fuente externa (por ejemplo, un archivo JSON)
    final String jsonString = await rootBundle.loadString('assets/expenses.json');
    final List<dynamic> jsonList = json.decode(jsonString);

    // Convertimos los datos JSON en objetos Expense
    return jsonList.map((json) => Expense.fromJson(json)).toList();
  }

  Future<void> addExpense(Expense expense) async {
    // Aquí implementarías la lógica para agregar un nuevo gasto a la fuente de datos
  }

  Future<void> updateExpense(Expense expense) async {
    // Aquí implementarías la lógica para actualizar un gasto en la fuente de datos
  }

  Future<void> deleteExpense(String id) async {
    // Aquí implementarías la lógica para eliminar un gasto de la fuente de datos
  }
}
