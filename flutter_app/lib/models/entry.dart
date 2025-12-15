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
    return Entry(
      id: int.parse(json['id'].toString()),
      userId: int.parse(json['user_id'].toString()),
      title: json['title'] as String,
      releaseYear: json['release_year'] != null ? int.parse(json['release_year'].toString()) : null,
      review: json['review'] as String?,
      rating: json['rating'] != null ? int.parse(json['rating'].toString()) : null,
      status: json['status'] as String,
      posterUrl: json['poster_url'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      userName: json['user_name'] as String?,
      likeCount: json['like_count'] != null ? int.parse(json['like_count'].toString()) : null,
    );
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
