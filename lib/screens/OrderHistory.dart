import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../models/order_model.dart';
import '../widgets/order_cards.dart';

class OrderHistoryPage extends StatefulWidget {
  @override
  _OrderHistoryPageState createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  List<Order> _orders = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('jwt_token');

      if (token != null) {
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        int userId = decodedToken['userId'];

        final response = await http.get(
          Uri.parse('http://10.0.2.2:3000/orders/history/$userId'),
        );

        if (response.statusCode == 200) {
          final List<dynamic> data = jsonDecode(response.body);
          setState(() {
            _orders = data.map((json) => Order.fromJson(json)).toList();
            _isLoading = false;
          });
        } else {
          setState(() {
            _errorMessage = 'Failed to load orders';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _errorMessage = 'No token found';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred';
        _isLoading = false;
      });
    }
  }
    @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Order History'),
        centerTitle: true,
      ),
      body: _isLoading
        ? Center(child: CircularProgressIndicator())
        : _errorMessage.isNotEmpty
          ? Center(child: Text(_errorMessage))
          : ListView.builder(
              itemCount: _orders.length,
              itemBuilder: (context, index) {
                final order = _orders[index];
                return OrderCard(order: order); 
              },
            ),
    );
  }
}


