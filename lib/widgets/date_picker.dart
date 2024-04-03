import 'package:flutter/material.dart';

class DateSelectorButton extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime?> onChanged;

  const DateSelectorButton({
    Key? key,
    required this.selectedDate,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        final DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2015, 8),
          lastDate: DateTime(2101),
        );
        if (pickedDate != null && pickedDate != selectedDate) {
          onChanged(pickedDate);
        }
      },
      child: Row(
        children: [
          const Icon(Icons.calendar_today), // Calendar icon as prefix
          const SizedBox(width: 10), // Spacer between icon and text
          Text('Fecha: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'),
        ],
      ),
    );
  }
}
