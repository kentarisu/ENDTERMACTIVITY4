import 'package:flutter/material.dart';
import '../models/entry.dart';
import '../services/api_client.dart';

class EntryProvider with ChangeNotifier {
  final ApiClient _apiClient;

  List<Entry> _entries = [];
  bool _isLoading = false;
  String? _error;

  EntryProvider(this._apiClient);

  List<Entry> get entries => _entries;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadEntries({String? status, int? userId}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _entries = await _apiClient.getEntries(status: status, userId: userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createEntry({
    required String title,
    int? releaseYear,
    String? review,
    int? rating,
    String status = 'planning',
    String? posterUrl,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final entry = await _apiClient.createEntry(
        title: title,
        releaseYear: releaseYear,
        review: review,
        rating: rating,
        status: status,
        posterUrl: posterUrl,
      );
      _entries.insert(0, entry);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateEntry(
    int id, {
    String? title,
    int? releaseYear,
    String? review,
    int? rating,
    String? status,
    String? posterUrl,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedEntry = await _apiClient.updateEntry(
        id,
        title: title,
        releaseYear: releaseYear,
        review: review,
        rating: rating,
        status: status,
        posterUrl: posterUrl,
      );
      final index = _entries.indexWhere((e) => e.id == id);
      if (index != -1) {
        _entries[index] = updatedEntry;
      }
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteEntry(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _apiClient.deleteEntry(id);
      _entries.removeWhere((e) => e.id == id);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<Entry> getEntry(int id) async {
    try {
      return await _apiClient.getEntry(id);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> likeEntry(int id) async {
    try {
      await _apiClient.likeEntry(id);
      // Reload the entry to get updated like count
      final index = _entries.indexWhere((e) => e.id == id);
      if (index != -1) {
        final updatedEntry = await _apiClient.getEntry(id);
        _entries[index] = updatedEntry;
        notifyListeners();
      }
      return true;
    } catch (e) {
      // Check if error is "Already liked" - this is expected behavior
      final errorMsg = e.toString().toLowerCase();
      if (errorMsg.contains('already liked')) {
        _error = null; // Not really an error, just already liked
        return false; // Return false to indicate we should unlike instead
      }
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> unlikeEntry(int id) async {
    try {
      await _apiClient.unlikeEntry(id);
      // Reload the entry to get updated like count
      final index = _entries.indexWhere((e) => e.id == id);
      if (index != -1) {
        final updatedEntry = await _apiClient.getEntry(id);
        _entries[index] = updatedEntry;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
