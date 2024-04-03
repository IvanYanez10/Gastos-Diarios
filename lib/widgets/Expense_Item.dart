import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';

class ExpenseItem extends StatelessWidget {
  final Expense expense;
  final Function()? onDelete;

  const ExpenseItem({super.key, required this.expense, this.onDelete});
  @override
  Widget build(BuildContext context) {
    String truncatedDescription = expense.description;
    if (truncatedDescription.length > 25) {
      truncatedDescription = '${truncatedDescription.substring(0, 25)}...';
    }
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        title: Text(truncatedDescription),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('\$${expense.amount}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold
            ),),
            Text(
              DateFormat('MMM dd, E').format(expense.date),
              style: const TextStyle(
                fontWeight: FontWeight.w300,
                color: Colors.black,
              ),
            )
          ],
        ),
      ),
    );
  }
}