import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/entry.dart';
import '../providers/entry_provider.dart';
import '../providers/auth_provider.dart';
import 'entry_form_screen.dart';

class EntryDetailScreen extends StatefulWidget {
  final int entryId;

  const EntryDetailScreen({super.key, required this.entryId});

  @override
  State<EntryDetailScreen> createState() => _EntryDetailScreenState();
}

class _EntryDetailScreenState extends State<EntryDetailScreen> {
  Entry? _entry;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadEntry();
  }

  Future<void> _loadEntry() async {
    try {
      final entryProvider = Provider.of<EntryProvider>(context, listen: false);
      final entry = await entryProvider.getEntry(widget.entryId);
      setState(() {
        _entry = entry;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteEntry() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Entry'),
        content: const Text('Are you sure you want to delete this entry?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final entryProvider = Provider.of<EntryProvider>(context, listen: false);
      final success = await entryProvider.deleteEntry(widget.entryId);
      if (success && mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Entry deleted')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final isOwner = _entry != null && authProvider.user != null &&
        _entry!.userId == authProvider.user!.id;

    return Scaffold(
      appBar: AppBar(
        title: Text(_entry?.title ?? 'Entry Detail'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          if (isOwner)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => EntryFormScreen(entry: _entry),
                  ),
                ).then((_) => _loadEntry());
              },
            ),
          if (isOwner)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteEntry,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                      const SizedBox(height: 16),
                      Text(
                        'Error loading entry',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _error!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadEntry,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _entry == null
                  ? const Center(child: Text('Entry not found'))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _entry!.title,
                                  style: Theme.of(context).textTheme.headlineMedium,
                                ),
                              ),
                              Chip(
                                label: Text(_entry!.status.toUpperCase()),
                                backgroundColor: _getStatusColor(_entry!.status),
                              ),
                            ],
                          ),
                          if (_entry!.releaseYear != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              'Release Year: ${_entry!.releaseYear}',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                          if (_entry!.rating != null) ...[
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber),
                                const SizedBox(width: 4),
                                Text(
                                  '${_entry!.rating}/10',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ],
                            ),
                          ],
                          if (_entry!.userName != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              'By: ${_entry!.userName}',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                            ),
                          ],
                          if (_entry!.likeCount != null && _entry!.likeCount! > 0) ...[
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.favorite, color: Colors.red, size: 16),
                                const SizedBox(width: 4),
                                Text('${_entry!.likeCount} likes'),
                              ],
                            ),
                          ],
                          const Divider(height: 32),
                          if (_entry!.review != null && _entry!.review!.isNotEmpty) ...[
                            Text(
                              'Review',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _entry!.review!,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(height: 16),
                          ],
                          Text(
                            'Created: ${_formatDate(_entry!.createdAt)}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.grey[600],
                                ),
                          ),
                          if (_entry!.updatedAt != _entry!.createdAt)
                            Text(
                              'Updated: ${_formatDate(_entry!.updatedAt)}',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                            ),
                        ],
                      ),
                    ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'planning':
        return Colors.blue[100]!;
      case 'watching':
        return Colors.orange[100]!;
      case 'watched':
        return Colors.green[100]!;
      default:
        return Colors.grey[100]!;
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateString;
    }
  }
}
