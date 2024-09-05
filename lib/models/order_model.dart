class Order {
  final int id;
  final String status;

  Order({required this.id, required this.status});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      status: json['status'],
    );
  }
}