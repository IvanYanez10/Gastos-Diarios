class Expense {
  final int id;
  final DateTime date;
  final double amount;
  final String description;
  final String status;

  Expense({
    required this.id,
    required this.date,
    required this.amount,
    required this.description,
    required this.status,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'],
      date: DateTime.parse(json['date']),
      amount: json['amount'].toDouble(), // Convert to double
      description: json['description'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'amount': amount,
      'description': description,
      'status': status,
    };
  }
}
