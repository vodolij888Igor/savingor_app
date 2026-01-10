import 'package:flutter/material.dart';
import 'package:savingor_app/core/i18n/app_strings.dart';

class ShoppingListScreen extends StatelessWidget {
  const ShoppingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppStrings.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(t.shoppingList),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.shopping_cart, size: 72, color: Colors.grey),
              const SizedBox(height: 12),
              Text(t.shoppingList,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              const Text('Create and manage your smart shopping lists here.',
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
