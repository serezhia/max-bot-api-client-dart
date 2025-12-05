/// Chat type definitions for Max Bot API
library;

/// Chat type enumeration
enum ChatType {
  dialog('dialog'),
  chat('chat'),
  channel('channel');

  final String value;
  const ChatType(this.value);

  static ChatType fromString(String value) {
    return ChatType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ChatType.dialog,
    );
  }
}

/// Chat status enumeration
enum ChatStatus {
  active('active'),
  removed('removed'),
  left('left'),
  closed('closed'),
  suspended('suspended');

  final String value;
  const ChatStatus(this.value);

  static ChatStatus fromString(String value) {
    return ChatStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ChatStatus.active,
    );
  }
}

/// Sender action enumeration
enum SenderAction {
  typingOn('typing_on'),
  sendingPhoto('sending_photo'),
  sendingVideo('sending_video'),
  sendingAudio('sending_audio'),
  sendingFile('sending_file'),
  markSeen('mark_seen');

  final String value;
  const SenderAction(this.value);

  static SenderAction fromString(String value) {
    return SenderAction.values.firstWhere(
      (e) => e.value == value,
      orElse: () => SenderAction.typingOn,
    );
  }
}

/// Chat permissions enumeration
enum ChatPermissions {
  readAllMessages('read_all_messages'),
  addRemoveMembers('add_remove_members'),
  addAdmins('add_admins'),
  changeChatInfo('change_chat_info'),
  pinMessage('pin_message'),
  write('write');

  final String value;
  const ChatPermissions(this.value);

  static ChatPermissions fromString(String value) {
    return ChatPermissions.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ChatPermissions.write,
    );
  }
}

/// Represents a chat
class Chat {
  final int chatId;
  final ChatType type;
  final ChatStatus status;
  final String? title;
  final ChatIcon? icon;
  final int lastEventTime;
  final int participantsCount;
  final int? ownerId;
  final Map<String, int?>? participants;
  final bool isPublic;
  final String? link;
  final String? description;
  final Map<String, dynamic>? dialogWithUser;
  final int? messagesCount;
  final String? chatMessageId;
  final Map<String, dynamic>? pinnedMessage;

  const Chat({
    required this.chatId,
    required this.type,
    required this.status,
    this.title,
    this.icon,
    required this.lastEventTime,
    required this.participantsCount,
    this.ownerId,
    this.participants,
    required this.isPublic,
    this.link,
    this.description,
    this.dialogWithUser,
    this.messagesCount,
    this.chatMessageId,
    this.pinnedMessage,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      chatId: json['chat_id'] as int,
      type: ChatType.fromString(json['type'] as String),
      status: ChatStatus.fromString(json['status'] as String),
      title: json['title'] as String?,
      icon: json['icon'] != null
          ? ChatIcon.fromJson(json['icon'] as Map<String, dynamic>)
          : null,
      lastEventTime: json['last_event_time'] as int,
      participantsCount: json['participants_count'] as int,
      ownerId: json['owner_id'] as int?,
      participants: (json['participants'] as Map<String, dynamic>?)?.map(
        (k, v) => MapEntry(k, v as int?),
      ),
      isPublic: json['is_public'] as bool,
      link: json['link'] as String?,
      description: json['description'] as String?,
      dialogWithUser: json['dialog_with_user'] as Map<String, dynamic>?,
      messagesCount: json['messages_count'] as int?,
      chatMessageId: json['chat_message_id'] as String?,
      pinnedMessage: json['pinned_message'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chat_id': chatId,
      'type': type.value,
      'status': status.value,
      'title': title,
      'icon': icon?.toJson(),
      'last_event_time': lastEventTime,
      'participants_count': participantsCount,
      'owner_id': ownerId,
      'participants': participants,
      'is_public': isPublic,
      'link': link,
      'description': description,
      'dialog_with_user': dialogWithUser,
      'messages_count': messagesCount,
      'chat_message_id': chatMessageId,
      'pinned_message': pinnedMessage,
    };
  }
}

/// Chat icon
class ChatIcon {
  final String url;

  const ChatIcon({required this.url});

  factory ChatIcon.fromJson(Map<String, dynamic> json) {
    return ChatIcon(url: json['url'] as String);
  }

  Map<String, dynamic> toJson() => {'url': url};
}

/// Chat member
class ChatMember {
  final int userId;
  final String name;
  final String? username;
  final bool isBot;
  final int lastActivityTime;
  final String? description;
  final String? avatarUrl;
  final String? fullAvatarUrl;
  final int lastAccessTime;
  final bool isOwner;
  final bool isAdmin;
  final int joinTime;
  final List<ChatPermissions>? permissions;

  const ChatMember({
    required this.userId,
    required this.name,
    this.username,
    required this.isBot,
    required this.lastActivityTime,
    this.description,
    this.avatarUrl,
    this.fullAvatarUrl,
    required this.lastAccessTime,
    required this.isOwner,
    required this.isAdmin,
    required this.joinTime,
    this.permissions,
  });

  factory ChatMember.fromJson(Map<String, dynamic> json) {
    return ChatMember(
      userId: json['user_id'] as int,
      name: json['name'] as String,
      username: json['username'] as String?,
      isBot: json['is_bot'] as bool,
      lastActivityTime: json['last_activity_time'] as int,
      description: json['description'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      fullAvatarUrl: json['full_avatar_url'] as String?,
      lastAccessTime: json['last_access_time'] as int,
      isOwner: json['is_owner'] as bool,
      isAdmin: json['is_admin'] as bool,
      joinTime: json['join_time'] as int,
      permissions: (json['permissions'] as List<dynamic>?)
          ?.map((e) => ChatPermissions.fromString(e as String))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'name': name,
      'username': username,
      'is_bot': isBot,
      'last_activity_time': lastActivityTime,
      'description': description,
      'avatar_url': avatarUrl,
      'full_avatar_url': fullAvatarUrl,
      'last_access_time': lastAccessTime,
      'is_owner': isOwner,
      'is_admin': isAdmin,
      'join_time': joinTime,
      'permissions': permissions?.map((e) => e.value).toList(),
    };
  }
}
