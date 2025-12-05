/// Markup type definitions for Max Bot API
library;

/// Base markup element class
sealed class MarkupElement {
  final String type;
  final int from;
  final int length;

  const MarkupElement({
    required this.type,
    required this.from,
    required this.length,
  });

  Map<String, dynamic> toJson();

  static MarkupElement fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String;
    return switch (type) {
      'user_mention' => UserMentionMarkup.fromJson(json),
      _ => throw ArgumentError('Unknown markup type: $type'),
    };
  }
}

/// User mention markup
class UserMentionMarkup extends MarkupElement {
  final String? userLink;
  final int? userId;

  const UserMentionMarkup({
    required super.from,
    required super.length,
    this.userLink,
    this.userId,
  }) : super(type: 'user_mention');

  factory UserMentionMarkup.fromJson(Map<String, dynamic> json) {
    return UserMentionMarkup(
      from: json['from'] as int,
      length: json['length'] as int,
      userLink: json['user_link'] as String?,
      userId: json['user_id'] as int?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'from': from,
      'length': length,
      if (userLink != null) 'user_link': userLink,
      if (userId != null) 'user_id': userId,
    };
  }
}
