class Order {
  final int id;
  final int userId;
  final int storeId;
  final DateTime orderDate;
  final String totalAmount;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<OrderItem> orderItems;

  Order({
    required this.id,
    required this.userId,
    required this.storeId,
    required this.orderDate,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.orderItems,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      userId: json['userId'],
      storeId: json['storeId'],
      orderDate: DateTime.parse(json['orderDate']),
      totalAmount: json['totalAmount'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      orderItems: (json['OrderItems'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
    );
  }
}


class OrderItem {
  final int id;
  final int orderId;
  final int productId;
  final int quantity;
  final List<String> sizes;
  final List<String> colors;
  final String priceAtPurchase;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Product product;

  OrderItem({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.quantity,
    required this.sizes,
    required this.colors,
    required this.priceAtPurchase,
    required this.createdAt,
    required this.updatedAt,
    required this.product,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      orderId: json['orderId'],
      productId: json['productId'],
      quantity: json['quantity'],
      sizes: List<String>.from(json['Sizes']),
      colors: List<String>.from(json['Colors']),
      priceAtPurchase: json['priceAtPurchase'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      product: Product.fromJson(json['Product']),
    );
  }
}

class Product {
  final String name;
  final String imageUrl;
  final Store store;

  Product({
    required this.name,
    required this.imageUrl,
    required this.store,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'],
      imageUrl: json['imageUrl'],
      store: Store.fromJson(json['Store']),
    );
  }
}

class Store {
  final String name;

  Store({
    required this.name,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      name: json['name'],
    );
  }
}
