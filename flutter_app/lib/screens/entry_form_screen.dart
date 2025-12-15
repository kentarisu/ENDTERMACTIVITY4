import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/entry.dart';
import '../providers/entry_provider.dart';

class EntryFormScreen extends StatefulWidget {
  final Entry? entry;

  const EntryFormScreen({super.key, this.entry});

  @override
  State<EntryFormScreen> createState() => _EntryFormScreenState();
}

class _EntryFormScreenState extends State<EntryFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _releaseYearController = TextEditingController();
  final _reviewController = TextEditingController();
  final _ratingController = TextEditingController();
  String _status = 'planning';

  bool get isEditing => widget.entry != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      final entry = widget.entry!;
      _titleController.text = entry.title;
      _releaseYearController.text = entry.releaseYear?.toString() ?? '';
      _reviewController.text = entry.review ?? '';
      _ratingController.text = entry.rating?.toString() ?? '';
      _status = entry.status;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _releaseYearController.dispose();
    _reviewController.dispose();
    _ratingController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final entryProvider = Provider.of<EntryProvider>(context, listen: false);
    final releaseYear = _releaseYearController.text.isEmpty
        ? null
        : int.tryParse(_releaseYearController.text);
    final rating = _ratingController.text.isEmpty
        ? null
        : int.tryParse(_ratingController.text);

    bool success;
    if (isEditing) {
      success = await entryProvider.updateEntry(
        widget.entry!.id,
        title: _titleController.text.trim(),
        releaseYear: releaseYear,
        review: _reviewController.text.trim().isEmpty
            ? null
            : _reviewController.text.trim(),
        rating: rating,
        status: _status,
      );
    } else {
      success = await entryProvider.createEntry(
        title: _titleController.text.trim(),
        releaseYear: releaseYear,
        review: _reviewController.text.trim().isEmpty
            ? null
            : _reviewController.text.trim(),
        rating: rating,
        status: _status,
      );
    }

    if (success && mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isEditing ? 'Entry updated' : 'Entry created'),
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(entryProvider.error ?? 'Failed to save entry'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final entryProvider = Provider.of<EntryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Entry' : 'New Entry'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Title is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _releaseYearController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Release Year',
                  border: OutlineInputBorder(),
                  helperText: 'e.g., 2023',
                ),
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final year = int.tryParse(value);
                    if (year == null) {
                      return 'Please enter a valid year';
                    }
                    if (year < 1888 || year > DateTime.now().year + 10) {
                      return 'Please enter a valid year';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _status,
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'planning', child: Text('Planning')),
                  DropdownMenuItem(value: 'watching', child: Text('Watching')),
                  DropdownMenuItem(value: 'watched', child: Text('Watched')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _status = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ratingController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Rating',
                  border: OutlineInputBorder(),
                  helperText: '1-10',
                ),
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final rating = int.tryParse(value);
                    if (rating == null) {
                      return 'Please enter a valid number';
                    }
                    if (rating < 1 || rating > 10) {
                      return 'Rating must be between 1 and 10';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _reviewController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Review',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: entryProvider.isLoading ? null : _handleSubmit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: entryProvider.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(isEditing ? 'Update Entry' : 'Create Entry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
