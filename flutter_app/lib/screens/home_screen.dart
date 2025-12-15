import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/entry_provider.dart';
import '../providers/auth_provider.dart';
import 'entry_detail_screen.dart';
import 'entry_form_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _selectedStatus;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EntryProvider>(context, listen: false).loadEntries();
    });
  }

  @override
  Widget build(BuildContext context) {
    final entryProvider = Provider.of<EntryProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('FlickLog'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _selectedStatus = value == 'all' ? null : value;
              });
              entryProvider.loadEntries(status: _selectedStatus);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'all', child: Text('All Entries')),
              const PopupMenuItem(value: 'planning', child: Text('Planning')),
              const PopupMenuItem(value: 'watching', child: Text('Watching')),
              const PopupMenuItem(value: 'watched', child: Text('Watched')),
            ],
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Icon(Icons.filter_list),
            ),
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text('Profile: ${authProvider.user?.displayName ?? "Unknown"}'),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: Text('Logout'),
              ),
            ],
            onSelected: (value) async {
              if (value == 'logout') {
                await authProvider.logout();
                if (mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                }
              }
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => entryProvider.loadEntries(status: _selectedStatus),
        child: entryProvider.isLoading && entryProvider.entries.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : entryProvider.entries.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.movie_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No entries yet',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap + to add your first entry',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[500],
                              ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: entryProvider.entries.length,
                    itemBuilder: (context, index) {
                      final entry = entryProvider.entries[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: _getStatusColor(entry.status),
                            child: Icon(
                              _getStatusIcon(entry.status),
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            entry.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (entry.releaseYear != null)
                                Text('Year: ${entry.releaseYear}'),
                              if (entry.rating != null)
                                Row(
                                  children: [
                                    const Icon(Icons.star, size: 16, color: Colors.amber),
                                    Text(' ${entry.rating}/10'),
                                  ],
                                ),
                              if (entry.userName != null)
                                Text('By: ${entry.userName}'),
                            ],
                          ),
                          trailing: entry.rating != null
                              ? Chip(
                                  label: Text('${entry.rating}/10'),
                                  avatar: const Icon(Icons.star, size: 16),
                                )
                              : null,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => EntryDetailScreen(entryId: entry.id),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const EntryFormScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'planning':
        return Colors.blue;
      case 'watching':
        return Colors.orange;
      case 'watched':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'planning':
        return Icons.schedule;
      case 'watching':
        return Icons.play_circle;
      case 'watched':
        return Icons.check_circle;
      default:
        return Icons.help;
    }
  }
}
