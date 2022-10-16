class Spend {
  final int id;
  final String title; // what are we spending on
  final double amount; // how much are we spending
  final DateTime date; // when are we spending

  // constructor
  Spend({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
  });

  // helper function to add data to database
  Map<String, dynamic> toMap() {
    return {
      // id will be generated automatically
      'title': title,
      'amount': amount.toString(), // sqflite doesn't support double
      'date': date.toString(), // sqflite doesn't support DateTime
    };
  }
}
