import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../widgets/OpenStreetMap.dart'; // Replace with your target page import

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  LatLng _markerPosition = LatLng(33.8938, 35.5018);

  // Track the selected payment method
  String _selectedPaymentMethod = '';

  // Function to set the selected payment method
  void _selectPaymentMethod(String method) {
    setState(() {
      _selectedPaymentMethod = method;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Payment'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 0, 5),
              child: Text(
                'Delivery Address',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: GestureDetector(
                onTap: () {
                  // Navigate to the specific page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OpenStreetMapScreen(),
                    ),
                  );
                },
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 2),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/images/imageMaps.png',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 0, 5),
              child: Text(
                'Payment Method',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 20),
            // Payment Method Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  // Credit/Debit Card Option
                  ListTile(
                    leading: Icon(Icons.credit_card, color: Colors.blue),
                    title: Text('Credit / Debit Card'),
                    trailing: _selectedPaymentMethod == 'card'
                        ? Icon(Icons.check_circle, color: Colors.green)
                        : null, // Show green tick if selected
                    selected: _selectedPaymentMethod == 'card',
                    onTap: () {
                      _selectPaymentMethod('card');
                    },
                  ),
                  Divider(), // Divider between payment options
                  // PayPal Option
                  ListTile(
                    leading: Icon(Icons.account_balance_wallet,
                        color: Colors.orange),
                    title: Text('PayPal'),
                    trailing: _selectedPaymentMethod == 'paypal'
                        ? Icon(Icons.check_circle, color: Colors.green)
                        : null,
                    selected: _selectedPaymentMethod == 'paypal',
                    onTap: () {
                      _selectPaymentMethod('paypal');
                    },
                  ),
                  Divider(),
                  // Cash on Delivery Option
                  ListTile(
                    leading: Icon(Icons.attach_money, color: Colors.green),
                    title: Text('Cash on Delivery'),
                    trailing: _selectedPaymentMethod == 'cash'
                        ? Icon(Icons.check_circle, color: Colors.green)
                        : null,
                    selected: _selectedPaymentMethod == 'cash',
                    onTap: () {
                      _selectPaymentMethod('cash');
                    },
                  ),
                ],
              ),
            ),
            // Conditionally show payment details input based on the selected method
            if (_selectedPaymentMethod == 'card') _buildCardPaymentFields(),
            if (_selectedPaymentMethod == 'paypal') _buildPayPalPaymentFields(),
            if (_selectedPaymentMethod == 'cash') _buildCashOnDeliveryMessage(),
          ],
        ),
      ),
    );
  }

  // Build input fields for Credit/Debit Card
  Widget _buildCardPaymentFields() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Enter your card details', style: TextStyle(fontSize: 18)),
          SizedBox(height: 10),
          TextField(
            decoration: InputDecoration(
              labelText: 'Card Number',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 10),
          TextField(
            decoration: InputDecoration(
              labelText: 'Expiry Date',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.datetime,
          ),
          SizedBox(height: 10),
          TextField(
            decoration: InputDecoration(
              labelText: 'CVV',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }

  // Build fields or message for PayPal
  Widget _buildPayPalPaymentFields() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Enter your PayPal email', style: TextStyle(fontSize: 18)),
          SizedBox(height: 10),
          TextField(
            decoration: InputDecoration(
              labelText: 'PayPal Email',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
        ],
      ),
    );
  }

  // Message for Cash on Delivery
  Widget _buildCashOnDeliveryMessage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        'You will pay with cash upon delivery.',
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}
