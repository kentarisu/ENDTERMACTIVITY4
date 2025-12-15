class User {
  final int id;
  final String email;
  final String displayName;
  final String createdAt;

  User({
    required this.id,
    required this.email,
    required this.displayName,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: int.parse(json['id'].toString()),
      email: json['email'] as String,
      displayName: json['display_name'] as String,
      createdAt: json['created_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'display_name': displayName,
      'created_at': createdAt,
    };
  }
}
