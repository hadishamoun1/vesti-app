// checkout.dart
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../widgets/OpenStreetMap.dart'; // Adjust the path if necessary

class PaymentScreen extends StatefulWidget {
  final int totalItems;
  final double totalPrice;

  PaymentScreen({required this.totalItems, required this.totalPrice});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  LatLng _markerPosition = LatLng(33.8938, 35.5018);
  String _streetName = 'Unknown'; // Field for the street name
  String _selectedPaymentMethod = '';

  void _selectPaymentMethod(String method) {
    setState(() {
      _selectedPaymentMethod = method;
    });
  }

  void _openMap() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OpenStreetMapScreen(
          onLocationSelected: (LatLng point, String streetName) {
            setState(() {
              _markerPosition = point;
              _streetName = streetName;
            });
          },
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _markerPosition = result['position'];
        _streetName = result['street'];
      });
    }
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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 16, 0, 5),
                      child: Text(
                        'Delivery Address',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: _openMap,
                      child: Container(
                        width: 120,
                        height: 120,
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
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Selected Address: $_streetName',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    SizedBox(height: 30),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 16, 0, 5),
                      child: Text(
                        'Payment Method',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.credit_card, color: Colors.blue),
                          title: Text('Credit / Debit Card'),
                          trailing: _selectedPaymentMethod == 'card'
                              ? Icon(Icons.check_circle, color: Colors.green)
                              : null,
                          selected: _selectedPaymentMethod == 'card',
                          onTap: () {
                            _selectPaymentMethod('card');
                          },
                        ),
                        Divider(),
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
                        ListTile(
                          leading:
                              Icon(Icons.attach_money, color: Colors.green),
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
                    if (_selectedPaymentMethod == 'card')
                      _buildCardPaymentFields(),
                    if (_selectedPaymentMethod == 'paypal')
                      _buildPayPalPaymentFields(),
                    if (_selectedPaymentMethod == 'cash')
                      _buildCashOnDeliveryMessage(),
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: 160,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text(
                    'Total Items: ${widget.totalItems}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total: ',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '\$${widget.totalPrice.toStringAsFixed(2)}',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle checkout action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      fixedSize: Size(400, 45),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Complete Payment',
                      style: TextStyle(fontSize: 21),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardPaymentFields() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Card Number',
              border: OutlineInputBorder(),
              prefixIcon: Icon(
                Icons.credit_card,
                color: Colors.blue,
              ),
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.datetime,
                  decoration: InputDecoration(
                    labelText: 'Expiration Date',
                    border: OutlineInputBorder(),
                    hintText: 'MM/YY',
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'CVV',
                    border: OutlineInputBorder(),
                    hintText: 'XXX',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPayPalPaymentFields() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          labelText: 'PayPal Email',
          border: OutlineInputBorder(),
          prefixIcon: Icon(
            Icons.email,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }

  Widget _buildCashOnDeliveryMessage() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Text(
        'You will pay in cash upon delivery.',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
