import 'package:flutter/material.dart';

class ShoppingListScreen extends StatelessWidget {
  const ShoppingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping List'),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.shopping_cart, size: 72, color: Colors.grey),
              SizedBox(height: 12),
              Text('Shopping List',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              SizedBox(height: 8),
              Text('Create and manage your smart shopping lists here.',
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
