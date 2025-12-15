import 'package:flutter/material.dart';
import 'pages/list_wheel_scroll_page.dart';
import 'pages/draggable_scrollable_page.dart';
import 'pages/carousel_scroll_page.dart';
import 'pages/contact_cards_page.dart';
import 'pages/shopping_list_page.dart';
import 'pages/todo_list_page.dart';
import 'pages/widget_list_page.dart';
import 'pages/product_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Vinyl Shop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music Vinyl Shop'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildListTile(
            context,
            'ListWheelScrollView',
            'Explore vinyls with wheel scroll',
            Icons.album,
            const ListWheelScrollPage(),
          ),
          _buildListTile(
            context,
            'DraggableScrollableSheet',
            'Draggable sheet with products',
            Icons.drag_handle,
            const DraggableScrollablePage(),
          ),
          _buildListTile(
            context,
            'CarouselScrollSheet',
            'Browse vinyls in carousel',
            Icons.view_carousel,
            const CarouselScrollPage(),
          ),
          _buildListTile(
            context,
            'Contact Cards',
            'Scrollable list of contact cards',
            Icons.contacts,
            const ContactCardsPage(),
          ),
          _buildListTile(
            context,
            'Shopping List',
            'Shopping list with dividers',
            Icons.shopping_cart,
            const ShoppingListPage(),
          ),
          _buildListTile(
            context,
            'To-Do List',
            'Add and manage tasks',
            Icons.checklist,
            const TodoListPage(),
          ),
          _buildListTile(
            context,
            'Widget List',
            'Flutter widgets showcase',
            Icons.widgets,
            const WidgetListPage(),
          ),
          _buildListTile(
            context,
            'Product List',
            'Custom product list with prices',
            Icons.shopping_bag,
            const ProductListPage(),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Widget page,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      child: ListTile(
        leading: Icon(icon, size: 40, color: Theme.of(context).colorScheme.primary),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
      ),
    );
  }
}

