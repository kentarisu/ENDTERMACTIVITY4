import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user.dart';
import '../models/entry.dart';

class ApiClient {
  final Dio _dio;
  final FlutterSecureStorage _storage;
  static const String _baseUrl = 'http://localhost/ENDTERMACTIVITY4/backend/public';
  // For Android emulator, use: 'http://10.0.2.2/ENDTERMACTIVITY4/backend/public'
  // For iOS simulator, use: 'http://localhost/ENDTERMACTIVITY4/backend/public'
  // For physical device, use your computer's IP: 'http://192.168.x.x/ENDTERMACTIVITY4/backend/public'

  ApiClient(this._dio, this._storage) {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.headers['Content-Type'] = 'application/json';
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: 'auth_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
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
      final entries = (response.data['entries'] as List)
          .map((json) => Entry.fromJson(json))
          .toList();
      return entries;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Entry> getEntry(int id) async {
    try {
      final response = await _dio.get('/api/entries/$id');
      return Entry.fromJson(response.data['entry']);
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
      final message = error.response?.data['message'] ?? 'An error occurred';
      return message;
    } else if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return 'Connection timeout. Please check your internet connection.';
    } else if (error.type == DioExceptionType.connectionError) {
      return 'Could not connect to server. Please check if the backend is running.';
    } else {
      return error.message ?? 'An unknown error occurred';
    }
  }
}
