import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/product_model.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:3000';

  Future<List<Product>> fetchProducts(String category) async {
    final response = await http.get(Uri.parse('$baseUrl/products/category/$category'));
    
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}

class ProductProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Product> _products = [];
  String _category = 'Shoes';
  bool _isLoading = false;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String get category => _category;

  set category(String value) {
    _category = value;
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _products = await _apiService.fetchProducts(_category);
    } catch (e) {
      print('Error fetching products: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}
