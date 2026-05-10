class ShoppingItem {
  final String id;
  final String title;
  final String? store;
  final double? price;
  int qty;
  bool isChecked;
  final DateTime createdAt;

  ShoppingItem({
    required this.id,
    required this.title,
    this.store,
    this.price,
    this.qty = 1,
    this.isChecked = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}
