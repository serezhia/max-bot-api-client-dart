/// User type definitions for Max Bot API
library;

/// Represents a Max messenger user
class User {
  final int userId;
  final String name;
  final String? username;
  final bool isBot;
  final int lastActivityTime;

  const User({
    required this.userId,
    required this.name,
    this.username,
    required this.isBot,
    required this.lastActivityTime,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'] as int,
      name: json['name'] as String,
      username: json['username'] as String?,
      isBot: json['is_bot'] as bool,
      lastActivityTime: json['last_activity_time'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'name': name,
      'username': username,
      'is_bot': isBot,
      'last_activity_time': lastActivityTime,
    };
  }
}

/// User with photo information
class UserWithPhoto extends User {
  final String? description;
  final String? avatarUrl;
  final String? fullAvatarUrl;

  const UserWithPhoto({
    required super.userId,
    required super.name,
    super.username,
    required super.isBot,
    required super.lastActivityTime,
    this.description,
    this.avatarUrl,
    this.fullAvatarUrl,
  });

  factory UserWithPhoto.fromJson(Map<String, dynamic> json) {
    return UserWithPhoto(
      userId: json['user_id'] as int,
      name: json['name'] as String,
      username: json['username'] as String?,
      isBot: json['is_bot'] as bool,
      lastActivityTime: json['last_activity_time'] as int,
      description: json['description'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      fullAvatarUrl: json['full_avatar_url'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'description': description,
      'avatar_url': avatarUrl,
      'full_avatar_url': fullAvatarUrl,
    };
  }
}
