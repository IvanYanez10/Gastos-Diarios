import 'package:flutter/material.dart';
import 'package:gastos_diarios/views/edit_expense_view.dart';
import './views/expense_list_view.dart';
import './views/add_expense_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const ExpenseListView(),
        '/add_expense': (context) => const AddExpenseView(),
      },
    );
  }
}
