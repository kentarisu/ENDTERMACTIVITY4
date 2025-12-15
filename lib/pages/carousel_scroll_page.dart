import 'package:flutter/material.dart';

class CarouselScrollPage extends StatefulWidget {
  const CarouselScrollPage({super.key});

  @override
  State<CarouselScrollPage> createState() => _CarouselScrollPageState();
}

class _CarouselScrollPageState extends State<CarouselScrollPage> {
  final PageController _pageController = PageController(viewportFraction: 0.8);
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _pageController.hasClients) {
        _currentPage = (_currentPage + 1) % 6;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.fastOutSlowIn,
        );
        _startAutoPlay();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  final List<Map<String, String>> albums = const [
    {'title': 'When We All Fall Asleep, Where Do We Go?', 'artist': 'Billie Eilish', 'year': '2019', 'image': 'https://upload.wikimedia.org/wikipedia/en/3/3b/Billie_Eilish_-_When_We_All_Fall_Asleep%2C_Where_Do_We_Go%3F.png'},
    {'title': 'SOUR', 'artist': 'Olivia Rodrigo', 'year': '2021', 'image': 'https://upload.wikimedia.org/wikipedia/en/b/b2/Olivia_Rodrigo_-_SOUR.png'},
    {'title': 'Positions', 'artist': 'Ariana Grande', 'year': '2020', 'image': 'https://upload.wikimedia.org/wikipedia/en/a/a0/Ariana_Grande_-_Positions.png'},
    {'title': 'This Is Why', 'artist': 'Paramore', 'year': '2023', 'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTVday5kL3hrOd136kSNSVflMka_Wgcb6xHBw&s'},
    {'title': 'I Used to Think I Could Fly', 'artist': 'Tate McRae', 'year': '2022', 'image': 'https://i.scdn.co/image/ab67616d00001e02f7108342ef45a402af8206b2'},
    {'title': 'Being Funny in a Foreign Language', 'artist': 'The 1975', 'year': '2022', 'image': 'https://i.scdn.co/image/ab67616d0000b2731f44db452a68e229650a302c'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CarouselScrollSheet'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          const SizedBox(height: 40),
          const Text(
            'Featured Albums',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30),
          SizedBox(
            height: 350,
            child: PageView.builder(
              controller: _pageController,
              itemCount: albums.length,
              itemBuilder: (context, index) {
                final album = albums[index];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.deepPurple,
                          Colors.purple.shade300,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            album['image']!,
                            width: 180,
                            height: 180,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.album,
                                size: 120,
                                color: Colors.white,
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            album['title']!,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          album['artist']!,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          album['year']!,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white60,
                          ),
                        ),
                      ],
                    ),
                );
              },
            ),
          ),
          const SizedBox(height: 40),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Swipe left or right to explore more albums',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

