import 'package:flutter/material.dart';

class ShoppingListPage extends StatelessWidget {
  const ShoppingListPage({super.key});

  final List<Map<String, dynamic>> shoppingItems = const [
    {'item': 'Classic Rock Vinyl Pack', 'quantity': 3, 'checked': true},
    {'item': 'Jazz Collection Box Set', 'quantity': 1, 'checked': false},
    {'item': 'Blues Masters Series', 'quantity': 2, 'checked': true},
    {'item': 'Vinyl Record Cleaner Kit', 'quantity': 1, 'checked': false},
    {'item': 'Record Player Needle', 'quantity': 2, 'checked': false},
    {'item': 'Vintage Album Covers', 'quantity': 5, 'checked': true},
    {'item': 'Protective Sleeves Pack', 'quantity': 10, 'checked': false},
    {'item': 'Turntable Mat', 'quantity': 1, 'checked': true},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping List'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView.separated(
        itemCount: shoppingItems.length,
        separatorBuilder: (context, index) => const Divider(
          height: 1,
          thickness: 1,
          indent: 16,
          endIndent: 16,
        ),
        itemBuilder: (context, index) {
          final item = shoppingItems[index];
          return ListTile(
            leading: Checkbox(
              value: item['checked'],
              onChanged: null,
            ),
            title: Text(
              item['item'],
              style: TextStyle(
                decoration: item['checked']
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
            subtitle: Text('Quantity: ${item['quantity']}'),
            trailing: Icon(
              item['checked'] ? Icons.check_circle : Icons.circle_outlined,
              color: item['checked'] ? Colors.green : Colors.grey,
            ),
          );
        },
      ),
    );
  }
}

