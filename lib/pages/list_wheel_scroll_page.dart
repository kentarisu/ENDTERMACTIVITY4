import 'package:flutter/material.dart';

class ListWheelScrollPage extends StatelessWidget {
  const ListWheelScrollPage({super.key});

  final List<Map<String, String>> vinyls = const [
    {'title': 'When We All Fall Asleep, Where Do We Go?', 'artist': 'Billie Eilish', 'price': '\$29.99', 'image': 'https://upload.wikimedia.org/wikipedia/en/3/3b/Billie_Eilish_-_When_We_All_Fall_Asleep%2C_Where_Do_We_Go%3F.png'},
    {'title': 'Preacher\'s Daughter', 'artist': 'Ethel Cain', 'price': '\$34.99', 'image': 'https://upload.wikimedia.org/wikipedia/en/thumb/7/74/Preachers_daughter_ethel_cain.png/250px-Preachers_daughter_ethel_cain.png'},
    {'title': 'Superache', 'artist': 'Conan Gray', 'price': '\$27.99', 'image': 'https://i.scdn.co/image/ab67616d0000b27360a89b781c62ffe2136e4396'},
    {'title': 'SOUR', 'artist': 'Olivia Rodrigo', 'price': '\$31.99', 'image': 'https://upload.wikimedia.org/wikipedia/en/b/b2/Olivia_Rodrigo_-_SOUR.png'},
    {'title': 'Submarine', 'artist': 'The Marías', 'price': '\$28.99', 'image': 'https://upload.wikimedia.org/wikipedia/en/9/9e/The_Mar%C3%ADas_-_Submarine.jpg'},
    {'title': 'Nicole', 'artist': 'NIKI', 'price': '\$33.99', 'image': 'https://upload.wikimedia.org/wikipedia/en/thumb/1/1d/Nicole_%28Album%29_cover.png/250px-Nicole_%28Album%29_cover.png'},
    {'title': 'Being Funny in a Foreign Language', 'artist': 'The 1975', 'price': '\$36.99', 'image': 'https://i.scdn.co/image/ab67616d0000b2731f44db452a68e229650a302c'},
    {'title': 'Positions', 'artist': 'Ariana Grande', 'price': '\$30.99', 'image': 'https://upload.wikimedia.org/wikipedia/en/a/a0/Ariana_Grande_-_Positions.png'},
    {'title': 'I Used to Think I Could Fly', 'artist': 'Tate McRae', 'price': '\$29.99', 'image': 'https://i.scdn.co/image/ab67616d00001e02f7108342ef45a402af8206b2'},
    {'title': 'This Is Why', 'artist': 'Paramore', 'price': '\$32.99', 'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTVday5kL3hrOd136kSNSVflMka_Wgcb6xHBw&s'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ListWheelScrollView'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListWheelScrollView(
        itemExtent: 150,
        diameterRatio: 2.0,
        perspective: 0.003,
        children: vinyls.map((vinyl) {
          return Card(
            elevation: 8,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      vinyl['image']!,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.album, size: 80, color: Colors.deepPurple);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          vinyl['title']!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          vinyl['artist']!,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          vinyl['price']!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

