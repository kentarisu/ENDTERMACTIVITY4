import 'package:flutter/material.dart';

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  final List<Map<String, dynamic>> products = const [
    {
      'name': 'When We All Fall Asleep, Where Do We Go?',
      'artist': 'Billie Eilish',
      'price': 29.99,
      'description': 'Genre-defying pop masterpiece',
      'rating': 5.0,
      'image': 'https://upload.wikimedia.org/wikipedia/en/3/3b/Billie_Eilish_-_When_We_All_Fall_Asleep%2C_Where_Do_We_Go%3F.png',
    },
    {
      'name': 'Preacher\'s Daughter',
      'artist': 'Ethel Cain',
      'price': 34.99,
      'description': 'Gothic Americana concept album',
      'rating': 4.9,
      'image': 'https://upload.wikimedia.org/wikipedia/en/thumb/7/74/Preachers_daughter_ethel_cain.png/250px-Preachers_daughter_ethel_cain.png',
    },
    {
      'name': 'Superache',
      'artist': 'Conan Gray',
      'price': 27.99,
      'description': 'Emotional indie pop journey',
      'rating': 4.7,
      'image': 'https://i.scdn.co/image/ab67616d0000b27360a89b781c62ffe2136e4396',
    },
    {
      'name': 'SOUR',
      'artist': 'Olivia Rodrigo',
      'price': 31.99,
      'description': 'Breakout pop-punk debut',
      'rating': 4.8,
      'image': 'https://upload.wikimedia.org/wikipedia/en/b/b2/Olivia_Rodrigo_-_SOUR.png',
    },
    {
      'name': 'Submarine',
      'artist': 'The Marías',
      'price': 28.99,
      'description': 'Dreamy psychedelic soul',
      'rating': 4.6,
      'image': 'https://upload.wikimedia.org/wikipedia/en/9/9e/The_Mar%C3%ADas_-_Submarine.jpg',
    },
    {
      'name': 'Nicole',
      'artist': 'NIKI',
      'price': 32.99,
      'description': 'Cinematic R&B storytelling',
      'rating': 4.7,
      'image': 'https://upload.wikimedia.org/wikipedia/en/thumb/1/1d/Nicole_%28Album%29_cover.png/250px-Nicole_%28Album%29_cover.png',
    },
    {
      'name': 'Being Funny in a Foreign Language',
      'artist': 'The 1975',
      'price': 36.99,
      'description': 'Modern commentary on digital life',
      'rating': 4.8,
      'image': 'https://i.scdn.co/image/ab67616d0000b2731f44db452a68e229650a302c',
    },
    {
      'name': 'Positions',
      'artist': 'Ariana Grande',
      'price': 30.99,
      'description': 'Empowering pop anthem collection',
      'rating': 4.9,
      'image': 'https://upload.wikimedia.org/wikipedia/en/a/a0/Ariana_Grande_-_Positions.png',
    },
    {
      'name': 'I Used to Think I Could Fly',
      'artist': 'Tate McRae',
      'price': 29.99,
      'description': 'Vulnerable pop exploration',
      'rating': 4.5,
      'image': 'https://i.scdn.co/image/ab67616d00001e02f7108342ef45a402af8206b2',
    },
    {
      'name': 'This Is Why',
      'artist': 'Paramore',
      'price': 32.99,
      'description': 'Colorful new wave-inspired rock',
      'rating': 4.8,
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTVday5kL3hrOd136kSNSVflMka_Wgcb6xHBw&s',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Card(
            elevation: 6,
            margin: const EdgeInsets.only(bottom: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      product['image'],
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.deepPurple.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.album,
                            size: 50,
                            color: Colors.deepPurple,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product['name'],
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          product['artist'],
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          product['description'],
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              size: 16,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              product['rating'].toString(),
                              style: const TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '\$${product['price'].toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Added ${product['name']} to cart!',
                                    ),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 8,
                                ),
                              ),
                              child: const Text('Buy'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

