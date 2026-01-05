import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user.dart';
import '../models/entry.dart';

class ApiClient {
  final Dio _dio;
  final FlutterSecureStorage _storage;
  static const String _baseUrl = 'https://d1b0ade205c4.ngrok-free.app';
  // For FlutLab Web Preview: Use your computer's IP address instead of localhost
  // Find your IP: Open Command Prompt, type 'ipconfig', look for IPv4 Address
  // Example: 'http://192.168.1.100:8000'
  // For Android emulator: 'http://10.0.2.2:8000'
  // For iOS simulator: 'http://localhost:8000'
  // For physical device: 'http://YOUR_COMPUTER_IP:8000'

  ApiClient(this._dio, this._storage) {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.headers['Content-Type'] = 'application/json';
    _dio.options.headers['ngrok-skip-browser-warning'] = 'true';
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: 'auth_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        // Always add ngrok skip warning header
        options.headers['ngrok-skip-browser-warning'] = 'true';
        handler.next(options);
      },
      onResponse: (response, handler) {
        // If response.data is a string, try to parse it as JSON
        if (response.data is String) {
          try {
            response.data = jsonDecode(response.data as String);
          } catch (e) {
            // If parsing fails, it's not JSON - pass through the error
          }
        }
        handler.next(response);
      },
      onError: (error, handler) {
        handler.next(error);
      },
    ));
  }

  // Auth methods
  Future<Map<String, dynamic>> register(String email, String password, String displayName) async {
    try {
      final response = await _dio.post(
        '/api/auth/register',
        data: {
          'email': email,
          'password': password,
          'displayName': displayName,
        },
      );
      final token = response.data['token'] as String;
      await _storage.write(key: 'auth_token', value: token);
      return {
        'token': token,
        'user': User.fromJson(response.data['user']),
      };
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/api/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );
      final token = response.data['token'] as String;
      await _storage.write(key: 'auth_token', value: token);
      return {
        'token': token,
        'user': User.fromJson(response.data['user']),
      };
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<User> getProfile() async {
    try {
      final response = await _dio.get('/api/auth/profile');
      return User.fromJson(response.data['user']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'auth_token');
  }

  // Entry methods
  Future<List<Entry>> getEntries({String? status, int? userId}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (status != null) queryParams['status'] = status;
      if (userId != null) queryParams['user_id'] = userId;

      final response = await _dio.get('/api/entries', queryParameters: queryParams);
      final data = response.data;
      
      // Validate response structure
      if (data is! Map<String, dynamic>) {
        throw 'Invalid response format: expected Map, got ${data.runtimeType}';
      }
      
      if (data['entries'] == null) {
        throw 'Entries not found in response. Response keys: ${data.keys.toList()}';
      }
      
      if (data['entries'] is! List) {
        throw 'Invalid entries format: expected List, got ${data['entries'].runtimeType}. Value: ${data['entries']}';
      }
      
      final entriesList = data['entries'] as List;
      final entries = entriesList
          .map((json) {
            try {
              if (json is! Map<String, dynamic>) {
                throw 'Invalid entry format: expected Map, got ${json.runtimeType}. Value: $json';
              }
              // After the check above, json is guaranteed to be Map<String, dynamic>
              return Entry.fromJson(json);
            } catch (e) {
              throw 'Error parsing entry: $e. Entry data: $json';
            }
          })
          .toList();
      return entries;
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw 'Error loading entries: $e';
    }
  }

  Future<Entry> getEntry(int id) async {
    try {
      final response = await _dio.get('/api/entries/$id');
      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw 'Invalid response format: expected Map, got ${data.runtimeType}';
      }
      if (data['entry'] == null) {
        throw 'Entry not found in response';
      }
      if (data['entry'] is! Map<String, dynamic>) {
        throw 'Invalid entry format: expected Map, got ${data['entry'].runtimeType}. Value: ${data['entry']}';
      }
      return Entry.fromJson(data['entry'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Entry> createEntry({
    required String title,
    int? releaseYear,
    String? review,
    int? rating,
    String status = 'planning',
    String? posterUrl,
  }) async {
    try {
      final response = await _dio.post(
        '/api/entries',
        data: {
          'title': title,
          'release_year': releaseYear,
          'review': review,
          'rating': rating,
          'status': status,
          'poster_url': posterUrl,
        },
      );
      return Entry.fromJson(response.data['entry']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Entry> updateEntry(
    int id, {
    String? title,
    int? releaseYear,
    String? review,
    int? rating,
    String? status,
    String? posterUrl,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (title != null) data['title'] = title;
      if (releaseYear != null) data['release_year'] = releaseYear;
      if (review != null) data['review'] = review;
      if (rating != null) data['rating'] = rating;
      if (status != null) data['status'] = status;
      if (posterUrl != null) data['poster_url'] = posterUrl;

      final response = await _dio.put('/api/entries/$id', data: data);
      return Entry.fromJson(response.data['entry']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> deleteEntry(int id) async {
    try {
      await _dio.delete('/api/entries/$id');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> likeEntry(int id) async {
    try {
      await _dio.post('/api/entries/$id/like');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> unlikeEntry(int id) async {
    try {
      await _dio.delete('/api/entries/$id/like');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException error) {
    if (error.response != null) {
      final data = error.response?.data;
      if (data is Map<String, dynamic>) {
        final message = data['message'] ?? 'An error occurred';
        final details = data['details'];
        if (details != null) {
          return '$message: $details';
        }
        return message.toString();
      }
      return 'An error occurred';
    } else if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return 'Connection timeout. Please check your internet connection.';
    } else if (error.type == DioExceptionType.connectionError) {
      // Provide more detailed error information
      final errorMsg = error.message ?? 'Unknown connection error';
      final baseUrl = _baseUrl;
      return 'Could not connect to server at $baseUrl. Error: $errorMsg. Please check if the backend is running and accessible.';
    } else {
      return error.message ?? 'An unknown error occurred';
    }
  }
}
