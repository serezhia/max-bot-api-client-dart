/// Bot type definitions for Max Bot API
library;

import 'user.dart';

/// Represents a bot command
class BotCommand {
  final String name;
  final String? description;

  const BotCommand({
    required this.name,
    this.description,
  });

  factory BotCommand.fromJson(Map<String, dynamic> json) {
    return BotCommand(
      name: json['name'] as String,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (description != null) 'description': description,
    };
  }
}

/// Represents bot information
class BotInfo extends UserWithPhoto {
  final List<BotCommand>? commands;

  const BotInfo({
    required super.userId,
    required super.name,
    super.username,
    required super.isBot,
    required super.lastActivityTime,
    super.description,
    super.avatarUrl,
    super.fullAvatarUrl,
    this.commands,
  });

  factory BotInfo.fromJson(Map<String, dynamic> json) {
    return BotInfo(
      userId: json['user_id'] as int,
      name: json['name'] as String,
      username: json['username'] as String?,
      isBot: json['is_bot'] as bool,
      lastActivityTime: json['last_activity_time'] as int,
      description: json['description'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      fullAvatarUrl: json['full_avatar_url'] as String?,
      commands: (json['commands'] as List<dynamic>?)
          ?.map((e) => BotCommand.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      if (commands != null)
        'commands': commands!.map((e) => e.toJson()).toList(),
    };
  }
}
