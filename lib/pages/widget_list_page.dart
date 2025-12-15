import 'package:flutter/material.dart';

class WidgetListPage extends StatelessWidget {
  const WidgetListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Widgets'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Text Widget',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'This is a regular text widget displaying information.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            const Text(
              'Icon Widget',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Icon(Icons.home, size: 50, color: Colors.blue),
                Icon(Icons.favorite, size: 50, color: Colors.red),
                Icon(Icons.star, size: 50, color: Colors.amber),
                Icon(Icons.music_note, size: 50, color: Colors.purple),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Image Widget',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.image,
                size: 100,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Container Widget',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple, Colors.blue],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'This is a styled Container widget with gradient background',
                style: TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Button Widgets',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Elevated Button'),
                ),
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('Outlined Button'),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('Text Button'),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.thumb_up),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Card Widget',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: const [
                    Icon(Icons.widgets, size: 50, color: Colors.deepPurple),
                    SizedBox(height: 8),
                    Text(
                      'Card Widget Example',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('Cards are used to display content'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'ListTile Widget',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 16),
            const ListTile(
              leading: Icon(Icons.album, color: Colors.deepPurple),
              title: Text('ListTile Title'),
              subtitle: Text('This is a subtitle'),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

