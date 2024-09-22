class Product {
  final String name;
  final String image;
  final List<String> sizes;
  final List<String> colors;

  Product({
    required this.name,
    required this.image,
    required this.sizes,
    required this.colors,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'],
      image: json['image'],
      sizes: List<String>.from(json['sizes']),
      colors: List<String>.from(json['colors']),
    );
  }
}
