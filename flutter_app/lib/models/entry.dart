class Entry {
  final int id;
  final int userId;
  final String title;
  final int? releaseYear;
  final String? review;
  final int? rating;
  final String status;
  final String? posterUrl;
  final String createdAt;
  final String updatedAt;
  final String? userName;
  final int? likeCount;

  Entry({
    required this.id,
    required this.userId,
    required this.title,
    this.releaseYear,
    this.review,
    this.rating,
    required this.status,
    this.posterUrl,
    required this.createdAt,
    required this.updatedAt,
    this.userName,
    this.likeCount,
  });

  factory Entry.fromJson(Map<String, dynamic> json) {
    try {
      // Helper function to safely parse integers
      int safeParseInt(dynamic value) {
        if (value == null) throw 'Value is null';
        if (value is int) return value;
        if (value is String) {
          if (value.isEmpty) throw 'Value is empty string';
          return int.parse(value);
        }
        if (value is double) return value.toInt();
        throw 'Cannot parse int from ${value.runtimeType}: $value';
      }

      return Entry(
        id: safeParseInt(json['id']),
        userId: safeParseInt(json['user_id']),
        title: json['title']?.toString() ?? '',
        releaseYear: json['release_year'] != null ? safeParseInt(json['release_year']) : null,
        review: json['review']?.toString(),
        rating: json['rating'] != null ? safeParseInt(json['rating']) : null,
        status: json['status']?.toString() ?? 'planning',
        posterUrl: json['poster_url']?.toString(),
        createdAt: json['created_at']?.toString() ?? '',
        updatedAt: json['updated_at']?.toString() ?? '',
        userName: json['user_name']?.toString(),
        likeCount: json['like_count'] != null ? safeParseInt(json['like_count']) : null,
      );
    } catch (e) {
      throw 'Error parsing Entry from JSON: $e. JSON: $json';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'release_year': releaseYear,
      'review': review,
      'rating': rating,
      'status': status,
      'poster_url': posterUrl,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  Entry copyWith({
    int? id,
    int? userId,
    String? title,
    int? releaseYear,
    String? review,
    int? rating,
    String? status,
    String? posterUrl,
    String? createdAt,
    String? updatedAt,
    String? userName,
    int? likeCount,
  }) {
    return Entry(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      releaseYear: releaseYear ?? this.releaseYear,
      review: review ?? this.review,
      rating: rating ?? this.rating,
      status: status ?? this.status,
      posterUrl: posterUrl ?? this.posterUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userName: userName ?? this.userName,
      likeCount: likeCount ?? this.likeCount,
    );
  }
}
