class Expense {
  const Expense({
    required this.id,
    required this.storeName,
    required this.itemName,
    required this.price,
    required this.category,
    required this.date,
  });

  final String id;
  final String storeName;
  final String itemName;
  final double price;
  final String category;
  final DateTime date;
}
