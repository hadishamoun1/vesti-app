import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          TextField(
            decoration: InputDecoration(labelText: 'Email'),
          ),
           TextField(
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
             SizedBox(height: 20),
            ElevatedButton(
              onPressed: () { },
               child: Text('Login'),
            ),
        ]),
      ),
    );
  }
}
