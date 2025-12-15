import 'package:flutter/material.dart';

class DraggableScrollablePage extends StatelessWidget {
  const DraggableScrollablePage({super.key});

  final List<Map<String, String>> products = const [
    {'name': 'Happier Than Ever', 'artist': 'Billie Eilish', 'price': '\$29.99', 'image': 'https://upload.wikimedia.org/wikipedia/en/4/45/Billie_Eilish_-_Happier_Than_Ever.png'},
    {'name': 'Preacher\'s Daughter', 'artist': 'Ethel Cain', 'price': '\$34.99', 'image': 'https://upload.wikimedia.org/wikipedia/en/thumb/7/74/Preachers_daughter_ethel_cain.png/250px-Preachers_daughter_ethel_cain.png'},
    {'name': 'Superache', 'artist': 'Conan Gray', 'price': '\$27.99', 'image': 'https://i.scdn.co/image/ab67616d0000b27360a89b781c62ffe2136e4396'},
    {'name': 'GUTS', 'artist': 'Olivia Rodrigo', 'price': '\$31.99', 'image': 'https://upload.wikimedia.org/wikipedia/en/0/03/Olivia_Rodrigo_-_Guts.png'},
    {'name': 'Submarine', 'artist': 'The Marías', 'price': '\$28.99', 'image': 'https://upload.wikimedia.org/wikipedia/en/9/9e/The_Mar%C3%ADas_-_Submarine.jpg'},
    {'name': 'Nicole', 'artist': 'NIKI', 'price': '\$33.99', 'image': 'https://upload.wikimedia.org/wikipedia/en/thumb/1/1d/Nicole_%28Album%29_cover.png/250px-Nicole_%28Album%29_cover.png'},
    {'name': 'Being Funny in a Foreign Language', 'artist': 'The 1975', 'price': '\$36.99', 'image': 'https://i.scdn.co/image/ab67616d0000b2731f44db452a68e229650a302c'},
    {'name': 'Positions', 'artist': 'Ariana Grande', 'price': '\$30.99', 'image': 'https://upload.wikimedia.org/wikipedia/en/a/a0/Ariana_Grande_-_Positions.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DraggableScrollableSheet'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.deepPurple.shade200,
                  Colors.deepPurple.shade50,
                ],
              ),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.album, size: 120, color: Colors.white),
                  SizedBox(height: 20),
                  Text(
                    'Drag the sheet up!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.3,
            minChildSize: 0.1,
            maxChildSize: 0.9,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: products.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Column(
                        children: [
                          const SizedBox(height: 8),
                          Container(
                            width: 40,
                            height: 5,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              'Featured Vinyls',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                    final product = products[index - 1];
                    return ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(
                          product['image']!,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.album, color: Colors.deepPurple);
                          },
                        ),
                      ),
                      title: Text(product['name']!),
                      subtitle: Text(product['artist']!),
                      trailing: Text(
                        product['price']!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

