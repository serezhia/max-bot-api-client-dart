/// Subscription/Update type definitions for Max Bot API
library;

import 'chat.dart';
import 'message.dart';
import 'user.dart';

/// Update type enumeration
enum UpdateType {
  messageCallback('message_callback'),
  messageCreated('message_created'),
  messageRemoved('message_removed'),
  messageEdited('message_edited'),
  botAdded('bot_added'),
  botRemoved('bot_removed'),
  userAdded('user_added'),
  userRemoved('user_removed'),
  botStarted('bot_started'),
  chatTitleChanged('chat_title_changed'),
  messageConstructionRequest('message_construction_request'),
  messageConstructed('message_constructed'),
  messageChatCreated('message_chat_created');

  final String value;
  const UpdateType(this.value);

  static UpdateType fromString(String value) {
    return UpdateType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Unknown update type: $value'),
    );
  }
}

/// Base update class
sealed class Update {
  final UpdateType updateType;
  final int timestamp;

  const Update({required this.updateType, required this.timestamp});

  Map<String, dynamic> toJson();

  static Update fromJson(Map<String, dynamic> json) {
    final type = UpdateType.fromString(json['update_type'] as String);
    return switch (type) {
      UpdateType.messageCallback => MessageCallbackUpdate.fromJson(json),
      UpdateType.messageCreated => MessageCreatedUpdate.fromJson(json),
      UpdateType.messageRemoved => MessageRemovedUpdate.fromJson(json),
      UpdateType.messageEdited => MessageEditedUpdate.fromJson(json),
      UpdateType.botAdded => BotAddedUpdate.fromJson(json),
      UpdateType.botRemoved => BotRemovedUpdate.fromJson(json),
      UpdateType.userAdded => UserAddedUpdate.fromJson(json),
      UpdateType.userRemoved => UserRemovedUpdate.fromJson(json),
      UpdateType.botStarted => BotStartedUpdate.fromJson(json),
      UpdateType.chatTitleChanged => ChatTitleChangedUpdate.fromJson(json),
      UpdateType.messageConstructionRequest =>
        MessageConstructionRequestUpdate.fromJson(json),
      UpdateType.messageConstructed => MessageConstructedUpdate.fromJson(json),
      UpdateType.messageChatCreated => MessageChatCreatedUpdate.fromJson(json),
    };
  }
}

/// Callback information
class Callback {
  final int timestamp;
  final String callbackId;
  final String? payload;
  final User user;

  const Callback({
    required this.timestamp,
    required this.callbackId,
    this.payload,
    required this.user,
  });

  factory Callback.fromJson(Map<String, dynamic> json) {
    return Callback(
      timestamp: json['timestamp'] as int,
      callbackId: json['callback_id'] as String,
      payload: json['payload'] as String?,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp,
      'callback_id': callbackId,
      'payload': payload,
      'user': user.toJson(),
    };
  }
}

/// Message callback update
class MessageCallbackUpdate extends Update {
  final Callback callback;
  final Message? message;
  final String? userLocale;

  const MessageCallbackUpdate({
    required super.timestamp,
    required this.callback,
    this.message,
    this.userLocale,
  }) : super(updateType: UpdateType.messageCallback);

  factory MessageCallbackUpdate.fromJson(Map<String, dynamic> json) {
    return MessageCallbackUpdate(
      timestamp: json['timestamp'] as int,
      callback: Callback.fromJson(json['callback'] as Map<String, dynamic>),
      message: json['message'] != null
          ? Message.fromJson(json['message'] as Map<String, dynamic>)
          : null,
      userLocale: json['user_locale'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'update_type': updateType.value,
      'timestamp': timestamp,
      'callback': callback.toJson(),
      'message': message?.toJson(),
      'user_locale': userLocale,
    };
  }
}

/// Message created update
class MessageCreatedUpdate extends Update {
  final Message message;
  final String? userLocale;

  const MessageCreatedUpdate({
    required super.timestamp,
    required this.message,
    this.userLocale,
  }) : super(updateType: UpdateType.messageCreated);

  factory MessageCreatedUpdate.fromJson(Map<String, dynamic> json) {
    return MessageCreatedUpdate(
      timestamp: json['timestamp'] as int,
      message: Message.fromJson(json['message'] as Map<String, dynamic>),
      userLocale: json['user_locale'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'update_type': updateType.value,
      'timestamp': timestamp,
      'message': message.toJson(),
      'user_locale': userLocale,
    };
  }
}

/// Message removed update
class MessageRemovedUpdate extends Update {
  final String messageId;
  final int chatId;
  final int userId;

  const MessageRemovedUpdate({
    required super.timestamp,
    required this.messageId,
    required this.chatId,
    required this.userId,
  }) : super(updateType: UpdateType.messageRemoved);

  factory MessageRemovedUpdate.fromJson(Map<String, dynamic> json) {
    return MessageRemovedUpdate(
      timestamp: json['timestamp'] as int,
      messageId: json['message_id'] as String,
      chatId: json['chat_id'] as int,
      userId: json['user_id'] as int,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'update_type': updateType.value,
      'timestamp': timestamp,
      'message_id': messageId,
      'chat_id': chatId,
      'user_id': userId,
    };
  }
}

/// Message edited update
class MessageEditedUpdate extends Update {
  final Message message;

  const MessageEditedUpdate({
    required super.timestamp,
    required this.message,
  }) : super(updateType: UpdateType.messageEdited);

  factory MessageEditedUpdate.fromJson(Map<String, dynamic> json) {
    return MessageEditedUpdate(
      timestamp: json['timestamp'] as int,
      message: Message.fromJson(json['message'] as Map<String, dynamic>),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'update_type': updateType.value,
      'timestamp': timestamp,
      'message': message.toJson(),
    };
  }
}

/// Bot added update
class BotAddedUpdate extends Update {
  final int chatId;
  final User user;
  final bool isChannel;

  const BotAddedUpdate({
    required super.timestamp,
    required this.chatId,
    required this.user,
    required this.isChannel,
  }) : super(updateType: UpdateType.botAdded);

  factory BotAddedUpdate.fromJson(Map<String, dynamic> json) {
    return BotAddedUpdate(
      timestamp: json['timestamp'] as int,
      chatId: json['chat_id'] as int,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      isChannel: json['is_channel'] as bool,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'update_type': updateType.value,
      'timestamp': timestamp,
      'chat_id': chatId,
      'user': user.toJson(),
      'is_channel': isChannel,
    };
  }
}

/// Bot removed update
class BotRemovedUpdate extends Update {
  final int chatId;
  final User user;
  final bool isChannel;

  const BotRemovedUpdate({
    required super.timestamp,
    required this.chatId,
    required this.user,
    required this.isChannel,
  }) : super(updateType: UpdateType.botRemoved);

  factory BotRemovedUpdate.fromJson(Map<String, dynamic> json) {
    return BotRemovedUpdate(
      timestamp: json['timestamp'] as int,
      chatId: json['chat_id'] as int,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      isChannel: json['is_channel'] as bool,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'update_type': updateType.value,
      'timestamp': timestamp,
      'chat_id': chatId,
      'user': user.toJson(),
      'is_channel': isChannel,
    };
  }
}

/// User added update
class UserAddedUpdate extends Update {
  final int chatId;
  final User user;
  final int? inviterId;
  final bool isChannel;

  const UserAddedUpdate({
    required super.timestamp,
    required this.chatId,
    required this.user,
    this.inviterId,
    required this.isChannel,
  }) : super(updateType: UpdateType.userAdded);

  factory UserAddedUpdate.fromJson(Map<String, dynamic> json) {
    return UserAddedUpdate(
      timestamp: json['timestamp'] as int,
      chatId: json['chat_id'] as int,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      inviterId: json['inviter_id'] as int?,
      isChannel: json['is_channel'] as bool,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'update_type': updateType.value,
      'timestamp': timestamp,
      'chat_id': chatId,
      'user': user.toJson(),
      'inviter_id': inviterId,
      'is_channel': isChannel,
    };
  }
}

/// User removed update
class UserRemovedUpdate extends Update {
  final int chatId;
  final User user;
  final int? adminId;
  final bool isChannel;

  const UserRemovedUpdate({
    required super.timestamp,
    required this.chatId,
    required this.user,
    this.adminId,
    required this.isChannel,
  }) : super(updateType: UpdateType.userRemoved);

  factory UserRemovedUpdate.fromJson(Map<String, dynamic> json) {
    return UserRemovedUpdate(
      timestamp: json['timestamp'] as int,
      chatId: json['chat_id'] as int,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      adminId: json['admin_id'] as int?,
      isChannel: json['is_channel'] as bool,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'update_type': updateType.value,
      'timestamp': timestamp,
      'chat_id': chatId,
      'user': user.toJson(),
      'admin_id': adminId,
      'is_channel': isChannel,
    };
  }
}

/// Bot started update
class BotStartedUpdate extends Update {
  final int chatId;
  final User user;
  final String? payload;
  final String? userLocale;

  const BotStartedUpdate({
    required super.timestamp,
    required this.chatId,
    required this.user,
    this.payload,
    this.userLocale,
  }) : super(updateType: UpdateType.botStarted);

  factory BotStartedUpdate.fromJson(Map<String, dynamic> json) {
    return BotStartedUpdate(
      timestamp: json['timestamp'] as int,
      chatId: json['chat_id'] as int,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      payload: json['payload'] as String?,
      userLocale: json['user_locale'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'update_type': updateType.value,
      'timestamp': timestamp,
      'chat_id': chatId,
      'user': user.toJson(),
      'payload': payload,
      'user_locale': userLocale,
    };
  }
}

/// Chat title changed update
class ChatTitleChangedUpdate extends Update {
  final int chatId;
  final User user;
  final String title;

  const ChatTitleChangedUpdate({
    required super.timestamp,
    required this.chatId,
    required this.user,
    required this.title,
  }) : super(updateType: UpdateType.chatTitleChanged);

  factory ChatTitleChangedUpdate.fromJson(Map<String, dynamic> json) {
    return ChatTitleChangedUpdate(
      timestamp: json['timestamp'] as int,
      chatId: json['chat_id'] as int,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      title: json['title'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'update_type': updateType.value,
      'timestamp': timestamp,
      'chat_id': chatId,
      'user': user.toJson(),
      'title': title,
    };
  }
}

/// Message construction request update
class MessageConstructionRequestUpdate extends Update {
  final User user;
  final String? userLocale;
  final String sessionId;
  final String? data;
  final dynamic input;

  const MessageConstructionRequestUpdate({
    required super.timestamp,
    required this.user,
    this.userLocale,
    required this.sessionId,
    this.data,
    this.input,
  }) : super(updateType: UpdateType.messageConstructionRequest);

  factory MessageConstructionRequestUpdate.fromJson(Map<String, dynamic> json) {
    return MessageConstructionRequestUpdate(
      timestamp: json['timestamp'] as int,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      userLocale: json['user_locale'] as String?,
      sessionId: json['session_id'] as String,
      data: json['data'] as String?,
      input: json['input'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'update_type': updateType.value,
      'timestamp': timestamp,
      'user': user.toJson(),
      'user_locale': userLocale,
      'session_id': sessionId,
      'data': data,
      'input': input,
    };
  }
}

/// Message constructed update
class MessageConstructedUpdate extends Update {
  final User user;
  final String sessionId;
  final ConstructedMessage message;

  const MessageConstructedUpdate({
    required super.timestamp,
    required this.user,
    required this.sessionId,
    required this.message,
  }) : super(updateType: UpdateType.messageConstructed);

  factory MessageConstructedUpdate.fromJson(Map<String, dynamic> json) {
    return MessageConstructedUpdate(
      timestamp: json['timestamp'] as int,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      sessionId: json['session_id'] as String,
      message:
          ConstructedMessage.fromJson(json['message'] as Map<String, dynamic>),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'update_type': updateType.value,
      'timestamp': timestamp,
      'user': user.toJson(),
      'session_id': sessionId,
      'message': message.toJson(),
    };
  }
}

/// Message chat created update
class MessageChatCreatedUpdate extends Update {
  final Chat chat;
  final String messageId;
  final String? startPayload;

  const MessageChatCreatedUpdate({
    required super.timestamp,
    required this.chat,
    required this.messageId,
    this.startPayload,
  }) : super(updateType: UpdateType.messageChatCreated);

  factory MessageChatCreatedUpdate.fromJson(Map<String, dynamic> json) {
    return MessageChatCreatedUpdate(
      timestamp: json['timestamp'] as int,
      chat: Chat.fromJson(json['chat'] as Map<String, dynamic>),
      messageId: json['message_id'] as String,
      startPayload: json['start_payload'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'update_type': updateType.value,
      'timestamp': timestamp,
      'chat': chat.toJson(),
      'message_id': messageId,
      'start_payload': startPayload,
    };
  }
}
