import 'package:flutter/material.dart';
import 'package:gastos_diarios/theme/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import './views/expense_list_view.dart';
import './views/add_expense_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1080, 2220),
      minTextAdapt: true,
      splitScreenMode: true,
    builder: (_ , child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: appTheme,
          initialRoute: '/',
          routes: {
            '/': (context) => const ExpenseListView(),
            '/add_expense': (context) => const AddExpenseView(),
          },
        );
      }
    );
  }
}